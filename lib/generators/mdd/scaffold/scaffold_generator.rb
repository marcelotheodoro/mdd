require 'rails/generators/migration'

module Mdd 

    class ScaffoldGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      attr_accessor :model, :model_attributes
      
      argument :scaffold_name, :type => :string, :banner => "[namespace]/Model"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      class_option :skip_migration, :desc => 'Skips the generation of a new migration', :type => :boolean
      class_option :ajax, :desc => 'Generates modal forms and AJAX submits', :type => :boolean

      def initialize(*args, &block)

        super

        @model = Generators::Model.new( scaffold_name )

        # model_name is not valid
        print_usage unless @model.valid?

        # sets the model attributes
        @model_attributes = []
        attributes.each do |attribute|
          @model_attributes << Generators::ModelAttribute.new( attribute, @model )
        end
      end

      def controller
        @inherit_controller = 'A::BackendController' if @model.space == 'a'
        template "controllers/#{'ajax_' if options.ajax}controller.rb", "app/controllers/#{@model.space}/#{@model.plural_name}_controller.rb"
      end

      def model
        template 'models/module.rb', "app/models/#{@model.space}.rb" unless @model.namespace?
        template 'models/model.rb', "app/models/#{@model.space}/#{@model.singular_name}.rb"
      end 

      def migration
        unless options.skip_migration
          migration_template 'db_migrate/migrate.rb', "db/migrate/create_#{@model.plural_name}.rb"
        end
      end

      def views
        template 'views/edit.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/edit.html.erb"
        template 'views/index.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/index.html.erb"
        template 'views/index.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/index.js.erb"
        template 'views/new.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/new.html.erb"
        template 'views/_form.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/_form.html.erb"
        template 'views/_list.html.erb', "app/views/#{@model.space}/#{@model.plural_name}/_#{@model.plural_name}.html.erb"

        if options.ajax
          template 'views/create.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/create.js.erb"
          template 'views/destroy.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/destroy.js.erb"
          template 'views/update.js.erb', "app/views/#{@model.space}/#{@model.plural_name}/update.js.erb"
        end
      end

      def routes
        route "resources :#{@model.plural_name}" unless @model.namespace?
        route "namespace :#{@model.space} do resources :#{@model.plural_name} end" if @model.namespace?
      end

      def run_rake_db_migrate
        unless options.skip_migration
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