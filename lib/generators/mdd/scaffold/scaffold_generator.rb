require 'rails/generators/migration'

module Mdd 

    class ScaffoldGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      attr_accessor :model, :create_nested_association
      
      argument :scaffold_name, :type => :string, :banner => "[namespace]/Model"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      class_option :ajax, :desc => 'Generates modal forms and AJAX submits.', :type => :boolean, :default => false
      class_option :skip_migration, :desc => 'Skips the generation of a new migration.', :type => :boolean, :default => false
      class_option :skip_timestamp, :desc => 'Skip timestamp generator on migration files.', :type => :boolean, :default => false
      class_option :skip_interface, :desc => 'Cretes only models, migrations and associations.', :type => :boolean, :default => false
      class_option :only_interface, :desc => 'Skips models, associations and migrations.', :type => :boolean, :default => false

      def initialize(*args, &block)

        super

        @model = Generators::Model.new( scaffold_name )

        # model_name is not valid
        print_usage unless @model.valid?

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
          template 'models/module.rb', "app/models/#{@model.space}.rb" if @model.namespace?
          template 'models/model.rb', "app/models/#{@model.space}/#{@model.singular_name}.rb"
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

      def routes
        unless options.skip_interface
          route "resources :#{@model.plural_name}" unless @model.namespace?
          route "namespace :#{@model.space} do resources :#{@model.plural_name} end" if @model.namespace?
        end
      end

      def migration
        unless options.skip_migration or options.only_interface
          migration_template 'db_migrate/migrate.rb', "db/migrate/create_#{@model.plural_name}.rb"
        end
      end

      def associations
        unless options.skip_migration or options.only_interface
          @model.attributes.select{ |a| a.references? }.each do |attr|
              # if attr.belongs_to? or attr.nested_one? or attr.has_one?
                generate "mdd:association #{@model.raw} #{attr.reference_type} #{attr.type.raw} #{'--force' if options.force} --skip_rake_migrate --ask"
              # else
              #   generate "mdd:association #{attr.type.raw} #{attr.reference_type} #{@model.raw} #{'--force' if options.force} --skip_rake_migrate --ask"
              # end
          end
        end
      end

      def run_rake_db_migrate
        unless options.skip_migration or options.only_interface
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