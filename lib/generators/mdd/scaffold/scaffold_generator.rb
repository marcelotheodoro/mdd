require 'rails/generators/migration'

module Mdd 

    class ScaffoldGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      attr_accessor :model, :specific_model
      
      argument :scaffold_name, :type => :string, :banner => "[namespace]/Model"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      class_option :model, :desc => 'Use if model is different than the scaffold name. Format: "[namespace]/Model"', :type => :string
      class_option :ajax, :desc => 'Generates modal forms and AJAX submits.', :type => :boolean, :default => false
      class_option :skip_migrations, :desc => 'Skips the generation of a new migration.', :type => :boolean, :default => false
      class_option :skip_timestamp, :desc => 'Skip timestamp generator on migration files.', :type => :boolean, :default => false
      class_option :skip_interface, :desc => 'Cretes only models, migrations and associations.', :type => :boolean, :default => false
      class_option :only_interface, :desc => 'Skips models, associations and migrations.', :type => :boolean, :default => false

      def initialize(*args, &block)

        super

        @model = Generators::Model.new( scaffold_name )        

        # model_name is not valid
        print_usage unless @model.valid?

        # verifies specific model name
        @specific_model = Generators::Model.new( options.model ) unless options.model.blank?
        if !@specific_model.nil?
          if !@specific_model.valid?
            print_usage 
          else
            @model.specific_model_name = @specific_model.raw
          end
        end

        # sets the model attributes
        attributes.each do |attribute|
          @model.add_attribute Generators::ModelAttribute.new( attribute )
        end

      end

      def controller
        unless options.skip_interface
          @inherit_controller = 'A::BackendController' if @model.space == 'a'
          template "controllers/#{'ajax_' if options.ajax}controller.rb", "app/controllers/#{@model.space}/#{@model.plural_name}_controller.rb"
        end
      end

      def model
        unless options.only_interface
          model = @model.specific_model || @model
          template 'models/module.rb', "app/models/#{model.space}.rb" if model.namespace?
          template 'models/model.rb', "app/models/#{model.space}/#{model.singular_name}.rb"
        end
      end

      def views
        unless options.skip_interface
          template 'views/edit.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/edit.html.erb"
          template 'views/index.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/index.html.erb"
          template 'views/index.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/index.js.erb"
          template 'views/new.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/new.html.erb"
          template 'views/show.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/show.html.erb"
          template 'views/_form.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/_form.html.erb"
          template 'views/_form_fields.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/_form_fields.html.erb"
          template 'views/_list.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/_#{@model.plural_name}.html.erb"

          if options.ajax
            #create and update are the same
            template 'views/create.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/create.js.erb"
            template 'views/create.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/update.js.erb"
            template 'views/destroy.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/destroy.js.erb"
          end
        end
      end
      
      def locales
        destination = 'config/locales/mdwa_model_specific.en.yml'
        inside Rails.root do
          create_file destination unless File.exist?(destination)
          append_file destination, "en:\n"
        end
        
        append_file destination, :after => "en:\n" do 
          lines = []
          lines <<  "  #{@model.plural_name}:"
          lines <<  "    create_success: \"#{@model.singular_name.humanize} created.\""
          lines <<  "    update_success: \"#{@model.singular_name.humanize} updated.\""
          lines <<  "    destroy_success: \"#{@model.singular_name.humanize} destroyed.\""
          lines <<  "    index_title: \"#{@model.plural_name.humanize}\""
          lines <<  "    show_title: \"#{@model.singular_name.humanize}\""
          lines <<  "    new_title: \"New #{@model.singular_name.humanize}\""
          lines <<  "    edit_title: \"Edit #{@model.singular_name.humanize}\""
          @model.attributes.each do |attr|
            lines <<  "    index_#{attr.name}: \"#{attr.name.humanize}\""
            lines <<  "    show_#{attr.name}: \"#{attr.name.humanize}\""
          end
          lines << "\n"
          lines.join("\n")
        end
      end

      def routes
        unless options.skip_interface
          route "resources :#{@model.plural_name}" unless @model.namespace?
          route "namespace :#{@model.space} do resources :#{@model.plural_name} end" if @model.namespace?
        end
      end

      def migration
        unless options.skip_migrations or options.only_interface
          migration_template 'db_migrate/migrate.rb', "db/migrate/create_#{@model.plural_name}.rb"
        end
      end

      def associations
        unless options.only_interface
          @model.attributes.select{ |a| a.references? }.each do |attr|
              generate "mdd:association #{@model.raw} #{attr.reference_type} #{attr.type.raw} #{'--skip_migrations' if options.skip_migrations} #{'--force' if options.force} --skip_rake_migrate --ask"
          end
        end
      end

      def run_rake_db_migrate
        unless options.skip_migrations or options.only_interface
          rake('db:migrate') if yes? 'Run rake db:migrate?'
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