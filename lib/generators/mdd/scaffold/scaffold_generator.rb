require 'rails/generators/migration'

module Mdd 

    class ScaffoldGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      attr_accessor :namespace, :model_name, :model_attributes
      
      argument :scaffold_name, :type => :string, :banner => "[namespace]/Model"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      class_option :skip_migration, :desc => 'Skips the generation of a new migration', :type => :boolean
      class_option :ajax, :desc => 'Generates modal forms and AJAX submits', :type => :boolean

      def initialize(*args, &block)

        super

        # separates model and namespace
        @namespace = ''
        @namespace = scaffold_name.split('/').first.camelize if scaffold_name.split('/').count > 1
        @model_name = scaffold_name.split('/').last.singularize.camelize

        # model_name is not valid
        print_usage unless @model_name.underscore =~ /^[a-z][a-z0-9_\/]+$/

        # sets the model attributes
        @model_attributes = []
        attributes.each do |attribute|
          @model_attributes << Generators::ModelAttribute.new( attribute )
        end
      end

      def controller
        @inherit_controller = 'A::BackendController' if @namespace.underscore == 'a'
        template "controllers/#{'ajax_' if options.ajax}controller.rb", "app/controllers/#{@namespace}/#{plural_name}_controller.rb"
      end

      def model
        template 'models/module.rb', "app/models/#{@namespace.underscore}.rb" unless @namespace.blank?
        template 'models/model.rb', "app/models/#{@namespace.underscore}/#{singular_name}.rb"
      end 

      def migration
        unless options.skip_migration
          migration_template 'db_migrate/migrate.rb', "db/migrate/create_#{plural_name}.rb"
        end
      end

      def views
        template 'views/edit.html.erb', "app/views/#{@namespace.underscore}/#{plural_name}/edit.html.erb"
        template 'views/index.html.erb', "app/views/#{@namespace.underscore}/#{plural_name}/index.html.erb"
        template 'views/index.js.erb', "app/views/#{@namespace.underscore}/#{plural_name}/index.js.erb"
        template 'views/new.html.erb', "app/views/#{@namespace.underscore}/#{plural_name}/new.html.erb"
        template 'views/_form.html.erb', "app/views/#{@namespace.underscore}/#{plural_name}/_form.html.erb"
        template 'views/_list.html.erb', "app/views/#{@namespace.underscore}/#{plural_name}/_#{plural_name}.html.erb"

        if options.ajax
          template 'views/create.js.erb', "app/views/#{@namespace.underscore}/#{plural_name}/create.js.erb"
          template 'views/destroy.js.erb', "app/views/#{@namespace.underscore}/#{plural_name}/destroy.js.erb"
          template 'views/update.js.erb', "app/views/#{@namespace.underscore}/#{plural_name}/update.js.erb"
        end
      end

      def routes
        route "resources :#{plural_name}" unless namespace?
        route "namespace :#{namespace.underscore} do resources :#{plural_name} end" if namespace?
      end

      def run_rake_db_migrate
        rake('db:migrate') if yes? 'Run rake db:migrate?'
      end

      private

        def singular_name
          @model_name.underscore
        end

        def plural_name
          @model_name.underscore.pluralize
        end

        def namespace_model_class
          "#{namespace_scope}#{@model_name}"
        end

        def namespace_scope
          return "#{@namespace}::" unless @namespace.blank?
          return ''
        end

        def namespace_object
          namespace_model_class.gsub('::', '_').underscore
        end

        def namespace?
          !namespace.blank?
        end

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