require 'rails/generators/migration'
require 'mdwa/generators'

module Mdwa
  
  module Generators

    class UserScaffoldGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      attr_accessor :model, :specific_model
      
      argument :scaffold_name, :type => :string, :banner => "[namespace]/Model"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      class_option :model, :desc => 'Use if model is different than the scaffold name. Format: "[namespace]/Model"', :type => :string
      class_option :ajax, :desc => 'Generates modal forms and AJAX submits.', :type => :boolean, :default => false
      class_option :skip_rake_migrate, :desc => 'Skips running rake db:migrate', :type => :boolean, :default => false
      class_option :skip_timestamp, :desc => 'Skip timestamp generator on migration files.', :type => :boolean, :default => false
      class_option :skip_questions, :desc => 'Answer no for all questions by default.', :type => :boolean, :default => false
      class_option :skip_interface, :desc => 'Cretes only models, migrations and associations.', :type => :boolean, :default => false
      class_option :only_interface, :desc => 'Skips models, associations and migrations.', :type => :boolean, :default => false

      def initialize(*args, &block)

        super

        @model = MDWA::Generators::Model.new( scaffold_name )        

        # model_name is not valid
        print_usage unless @model.valid?

        # verifies specific model name
        @specific_model = MDWA::Generators::Model.new( options.model ) unless options.model.blank?
        if !@specific_model.nil?
          if !@specific_model.valid?
            print_usage 
          else
            @model.specific_model_name = @specific_model.raw
          end
        end
        
        require_all "#{Rails.root}/app/models/user.rb"
        @predefined_fields = User.column_names
        @predefined_fields << 'password'
        @predefined_fields << 'password_confirmation'
        
        # sets the model attributes
        attributes.each do |attribute|
          @model.add_attribute MDWA::Generators::ModelAttribute.new( attribute ) unless User.accessible_attributes.to_a.include?( attribute.split(':').first )
        end
        
        generate "mdwa:scaffold #{scaffold_name} name:string email:string password:password password_confirmation:password #{attributes.join(' ')} #{'--force' if options.force} #{'--ajax' if options.ajax} #{"model=#{options.model}" if options.model} #{'--skip_interface' if options.skip_interface} #{'--only_interface' if options.only_interface} #{'--skip_rake_migrate' if options.skip_rake_migrate} #{'--skip_timestamp' if options.skip_timestamp} #{'--skip_questions' if options.skip_questions} --skip-migrations"

      end

      def controller_and_view
        unless options.skip_interface
          # controllers
          @inherit_controller = 'A::BackendController' if @model.space == 'a'
          template "controllers/#{'ajax_' if options.ajax}controller.rb", "app/controllers/#{@model.space}/#{@model.plural_name}_controller.rb"
          
          # views - update only 
          template 'views/update.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/update.js.erb"
        end
      end
      
      def model_override
        # locate the mdwa user to discover the roles
        require_all "#{MDWA::DSL::USERS_PATH}#{@model.singular_name}.rb"
        @mdwa_user = MDWA::DSL.user(@model.name)
        if @mdwa_user.nil?
          @roles = [@model.name]
        else
          @roles = @mdwa_user.user_roles
        end
        
        # model override
        gsub_file "app/models/#{@model.space}/#{@model.singular_name}.rb", 'ActiveRecord::Base', 'User'
        inject_into_class "app/models/#{@model.space}/#{@model.singular_name}.rb", @model.model_class do 
          inj = []
          @roles.each do |role|
            inj << "\n\n\tafter_create :create_#{role}_permission\n"
            inj << "\tdef create_#{role}_permission"
            inj << "\t\t#{role}_permission = Permission.find_by_name('#{role}')"
            inj << "\t\t#{role}_permission = Permission.create(:name => '#{role}') if #{role}_permission.nil?" 
            inj << "\t\tself.permissions.push #{role}_permission"
            inj << "\tend"
          end
          inj.join("\n")
        end
      end

      def migration_override        

        # override model attributes to not allow field duplicity (causing errorss)
        @model.attributes = []
        attributes.each do |attribute|
          @model.add_attribute MDWA::Generators::ModelAttribute.new( attribute ) unless @predefined_fields.include?( attribute.split(':').first )
        end
        migration_template 'migrate.rb', "db/migrate/add_#{@model.attributes.collect{|a| a.name}.join('_')}_to_users" unless @model.attributes.empty?
        
        # include type in db:seed
        append_file 'db/seeds/site.rb' do
          "\n\nPermission.create( :name => '#{@model.singular_name}' ) if Permission.find_by_name('#{@model.singular_name}').nil?"
        end
        # run rake db:seeds
        if yes?('Run rake db:seed to create permission type?')
          rake 'db:migrate'
          rake 'db:seed' 
        end
      end


      def run_rake_db_migrate
        if !options.skip_rake_migrate and !options.skip_migrations and !options.only_interface
          rake('db:migrate') if !options.skip_questions and yes? 'Run rake db:migrate?'
        end
      end

      private

        # Sets Rails migration timestamp
        def self.next_migration_number(dirname) #:nodoc:
          if ActiveRecord::Base.timestamped_migrations
            Time.now.utc.strftime("%Y%m%d%H%M%S")
          else
            "%.3d" % (current_migration_number(dirname) + 1)
          end
        end

    end

  end 
end