require 'erb'
require 'mdwa/dsl'

module Mdwa
  module Generators
   
    class TransformGenerator < Rails::Generators::Base
      
      def initialize(*args, &block)
        super
        
        # include files with entities
        # select entities that will be generated
        inside Rails.root do
          require_all MDWA::DSL::STRUCTURAL_PATH unless Dir.glob("#{MDWA::DSL::STRUCTURAL_PATH}/*.rb").count.zero?
        end
        @entities = MDWA::DSL.entities.all
        
      end
      
      def generate_model
        @entities.each do |entity|
          generator_model = entity.generator_model
          mdwa_template "#{entity.file_name}/model.rb", "app/models/#{generator_model.space}/#{generator_model.singular_name}.rb"
        end
      end
      
      def generate_controller
        @entities.each do |entity|
          generator_model = entity.generator_model
          mdwa_template "#{entity.file_name}/controller.rb", "app/controllers/#{generator_model.space}/#{generator_model.plural_name}_controller.rb"
        end
      end
      
      def generate_views
        @entities.each do |entity|
          generator_model = entity.generator_model

          mdwa_template "#{entity.file_name}/views/edit.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/edit.html.erb"        
          mdwa_template "#{entity.file_name}/views/index.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/index.html.erb"
          mdwa_template "#{entity.file_name}/views/index.js.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/index.js.erb"
          mdwa_template "#{entity.file_name}/views/new.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/new.html.erb"
          mdwa_template "#{entity.file_name}/views/show.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/show.html.erb"
          mdwa_template "#{entity.file_name}/views/_form.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/_form.html.erb"
          mdwa_template "#{entity.file_name}/views/_form_fields.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/_form_fields.html.erb"
          mdwa_template "#{entity.file_name}/views/_list.html.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/_#{generator_model.plural_name}.html.erb"
        
          if entity.ajax?
            mdwa_template "#{entity.file_name}/views/create.js.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/create.js.erb"
            mdwa_template "#{entity.file_name}/views/update.js.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/update.js.erb"
            mdwa_template "#{entity.file_name}/views/destroy.js.erb", "app/views/#{generator_model.space}/#{generator_model.plural_name}/destroy.js.erb"
          end
        end
      end
      
      def generate_routes
        
        route 'mdwa_router(self)'
        path_to_routes = 'app/mdwa/templates/routes.rb'
        append_to_file 'config/routes.rb', "require File.expand_path('../../#{path_to_routes}', __FILE__)"
        
        @entities.each do |entity|
          generator_model = entity.generator_model
        
          insert_into_file path_to_routes, :after => "controller :#{generator_model.plural_name} do" do
            routes = []
            entity.actions.generate_routes.each do |action_name, generation_string|
              routes << "\n\t\t\t#{generation_string}"
            end
            routes.join
          end
        end
      end
      
      def generate_locales
      end
      
      def generate_migration
        
        @entities.each do |entity|
          generator_model = entity.generator_model
        
          migration_string = []
          # create table
          migration_string << "\n\tdef self.up"
          migration_string << "\t\tcreate_table :#{generator_model.plural_name} do |t|"
          generator_model.simple_attributes.each do |attr|
          	migration_string << "\t\t\tt.#{attr.migration_field} :#{attr.name}"
        	end
          migration_string << "\t\t\tt.timestamps"
          migration_string << "\t\tend\n\tend"

          # drop table
          migration_string << "\n\tdef self.down"
          migration_string << "\t\tdrop_table :#{generator_model.plural_name}"
          migration_string << "\tend"
        
          migration_name = "create_#{generator_model.plural_name}"
          migration_from_string(migration_name, migration_string.join("\n"))
        end
        
        rake('db:migrate') if yes?('Run rake db:migrate')
        
      end
      
      def generate_tests
      end
      
      private
        
        def mdwa_template(file_to_read, file_to_write)
          read = File.read("#{Rails.root}/#{MDWA::DSL::TEMPLATES_PATH}/#{file_to_read}")
          erb = ERB.new(read, nil, '-')

          create_file "#{Rails.root}/#{file_to_write}", erb.result, :force => true
        end
        
        def migration_from_string(file_name, migration_string)
          
          # migration number
          if ActiveRecord::Base.timestamped_migrations
            @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S")
          else
            @migration_number = "%.3d" % (current_migration_number(Rails.root + 'db/migrate') + 1)
          end
          
          # incluir classe na migration
          migration_string = "# -*- encoding : utf-8 -*-\nclass #{file_name.camelize} < ActiveRecord::Migration\n#{migration_string}\nend"
          create_file "#{Rails.root}/db/migrate/#{@migration_number}_#{file_name}.rb", migration_string
          
        end
      
    end
    
  end
end