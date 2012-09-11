require 'erb'
require 'mdwa/dsl'

require 'rails/generators'
require 'rails/generators/migration'


module Mdwa
  module Generators
   
    class TransformGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      attr_accessor :pending_migrations
      
      argument :entities, :type => :array, :banner => 'Entities to transform', :default => []
      
      source_root File.expand_path("../templates", __FILE__)
      
      def initialize(*args, &block)
        super
        
        # control if there are any migrations to execute
        @pending_migrations = false
        
        # include files with entities
        inside Rails.root do
          require_all MDWA::DSL::STRUCTURAL_PATH unless Dir.glob("#{MDWA::DSL::STRUCTURAL_PATH}/*.rb").count.zero?
        end
        # select entities that will be generated
        if entities.count.zero?
          @entities = MDWA::DSL.entities.all 
        else
          @entities = entities.collect{ |e| MDWA::DSL.entity(e) }
        end
        
        # entity changes and migrations
        @changes = []
        @random_migration_key = rand.to_s.gsub('.','').to_i
        
        run 'rake db:migrate'
      end
      
      def generate_model_controller_helper_views
        @entities.each do |entity|
          generator_model = entity.generator_model
          
          namespaces = Dir.glob("#{Rails.root}/#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/*").select{|d| File.directory?(d) and File.basename(d) != 'views'}
          if !namespaces.count.zero?
            namespaces.each do |namespace|
              mdwa_template "#{entity.file_name}/#{File.basename namespace}/model.rb", "app/models/#{File.basename namespace}/#{generator_model.singular_name}.rb"
              mdwa_template "#{entity.file_name}/#{File.basename namespace}/helper.rb", "app/helpers/#{File.basename namespace}/#{generator_model.plural_name}_helper.rb"
              mdwa_template "#{entity.file_name}/#{File.basename namespace}/controller.rb", "app/controllers/#{File.basename namespace}/#{generator_model.plural_name}_controller.rb"
              Dir.glob("#{namespace}/views/*").each do |file|
                file_name = File.basename(file)
                mdwa_template "#{entity.file_name}/#{File.basename namespace}/views/#{file_name}", "app/views/#{File.basename namespace}/#{generator_model.plural_name}/#{file_name}"
              end
            end
          else
            entity_name = "#{Rails.root}/#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}"
            mdwa_template "#{entity_name}/model.rb", "app/models/#{generator_model.space}/#{generator_model.singular_name}.rb"
            mdwa_template "#{entity_name}/helper.rb", "app/helpers/#{generator_model.space}/#{generator_model.plural_name}_helper.rb"
            mdwa_template "#{entity_name}/controller.rb", "app/controllers/#{generator_model.space}/#{generator_model.plural_name}_controller.rb"
            Dir.glob("#{entity_name}/views/*").each do |file|
              file_name = File.basename(file)
              mdwa_template "#{entity.file_name}/views/#{file_name}", "app/views/#{generator_model.space}/#{generator_model.plural_name}/#{file_name}"
            end
          end
        end
      end
      
      def generate_routes
        
        route 'mdwa_router(self)'
        path_to_routes = 'app/mdwa/templates/routes.rb'
        insert_into_file 'config/routes.rb', "load File.expand_path('../../#{path_to_routes}', __FILE__)\n\n", :before => /.+::Application\.routes\.draw do(?:\s*\|map\|)?\s*$/
        
        # clear routes file contents
        File.truncate(path_to_routes, 0)
        append_file path_to_routes, "def mdwa_router(router)\n\nend"
        
        @entities.each do |entity|
          generator_model = entity.generator_model
          
          # inject scaffold code
          inject_into_file path_to_routes, :after => "def mdwa_router(router)\n" do
            route_str = []
            route_str << "\n\tnamespace :#{generator_model.space} do" if generator_model.namespace?
            route_str << "\t\tcontroller :#{generator_model.plural_name} do"
            route_str << "\t\tend"
            route_str << "\t\tresources :#{generator_model.plural_name}"
            route_str << "\tend\n" if generator_model.namespace?
                
            route_str.join "\n"
          end
        
          # inject specific actions
          inject_into_file path_to_routes, :after => "controller :#{generator_model.plural_name} do" do
            routes = []
            entity.actions.generate_routes.each do |action_name, generation_string|
              routes << "\n\t#{generation_string}"
            end
            routes.join
          end
        end
      end
      
      def generate_locales

        locales_file = 'config/locales/mdwa_model_specific.en.yml'
        locales_content = File.read(locales_file)
        # make sure the file exist
        create_file locales_file unless File.exist?(Rails.root + locales_file)
        
        @entities.each do |entity|
          model = entity.generator_model
          if !locales_content.include?( "  #{model.plural_name}:" )
            append_file locales_file, :after => "en:\n" do 
              lines = []
              lines <<  "  #{model.plural_name}:"
              lines <<  "    create_success: \"#{model.singular_name.humanize} created.\""
              lines <<  "    update_success: \"#{model.singular_name.humanize} updated.\""
              lines <<  "    destroy_success: \"#{model.singular_name.humanize} destroyed.\""
              lines <<  "    index_title: \"#{model.plural_name.humanize}\""
              lines <<  "    show_title: \"#{model.singular_name.humanize}\""
              lines <<  "    new_title: \"New #{model.singular_name.humanize}\""
              lines <<  "    edit_title: \"Edit #{model.singular_name.humanize}\""
              model.attributes.each do |attr|
                lines <<  "    index_#{attr.name}: \"#{attr.name.humanize}\""
                lines <<  "    show_#{attr.name}: \"#{attr.name.humanize}\""
              end
              model.associations.each do |assoc|
                if assoc.belongs_to? or assoc.nested_one? or assoc.has_one?
                  lines <<  "    index_#{assoc.model2.singular_name}: \"#{assoc.model2.singular_name.humanize}\""
                  lines <<  "    show_#{assoc.model2.singular_name}: \"#{assoc.model2.singular_name.humanize}\""
                else
                  lines <<  "    index_#{assoc.model2.singular_name}: \"#{assoc.model2.plural_name.humanize}\""
                  lines <<  "    show_#{assoc.model2.singular_name}: \"#{assoc.model2.plural_name.humanize}\""
                end
              end
              lines << "\n"
              lines.join("\n")
            end
          end
          
        end # @entities loop

      end
      
      def generate_migrations
        
        @entities.each do |entity|
          # if it's not a resource, ignore
          next unless entity.resource?
        
          # if model does not exist, should generate scaffold
          begin
            model_class = entity.generator_model.model_class
          rescue
            model_class = nil
          end
          
          # if is a new scaffold, generate migration for scaffold
          if (model_class.nil? or !model_class.table_exists?) and !entity.user?
            migration_for_entity(entity) 
            next
          end
          
          # generate new fields for users
          if entity.user?
            generation_string = "#{entity.generate} --only_diff_migration --skip_rake_migrate --skip-questions #{'--force' if options.force}"
            generate generation_string
          end
          
        end # @entities loop
      end
      
      
      def generate_changes_in_attributes
        
        @entities.each do |entity|
          # do not generate migrations for users changes
          next if entity.user?
          # if it's not a resource, ignore
          next unless entity.resource?
          
          # if model does not exist, should generate scaffold
          begin
            model_class = entity.generator_model.model_class
          rescue
            model_class = nil
          end
          
          # if table is not created yet, ignore
          next if model_class.nil? or !model_class.table_exists?
          
          # search for changes in this entity
          model_class.columns.each do |column|
            
            # ignore rails default columns and attributes used in associations
            next if column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at' or column.name.end_with? '_id'
            
            # ignores files
            
            entity_attribute = entity.attributes[column.name]
            # model attribute exists, but not in entity -> was erased
            if entity_attribute.nil?
              @changes << {:entity => entity, :type => 'remove_column', :column => column.name, :attr_type => column.type}
            # attribute exists in model and entity, but changed type
            elsif entity_attribute.type.to_sym != column.type.to_sym
              next if entity_attribute.type.to_sym == :file or entity_attribute.type.to_sym == :password or (column.type.to_sym == :integer and entity_attribute.type.to_sym == :float)
              @changes << {:entity => entity, :type => 'change_column', :column => column.name, :attr_type => entity_attribute.type, :from => column.type}
            end
          end
          
          # new attributes
          # no column with that name -> column must be added
          entity.attributes.each do |key, attr|
            if model_class.columns.select {|c| c.name == attr.name}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => attr.name, :attr_type => attr.type}
            end
          end
          
          # new foreign keys
          # belongs_to and nested_one associations that are in the entity, but not database
          entity.generator_model.associations.select{|a| a.belongs_to? or a.nested_one?}.each do |assoc|
            if model_class.columns.select{|c| c.name == assoc.model2.singular_name.foreign_key}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => assoc.model2.name.foreign_key, :attr_type => 'integer'}
            end
          end
          
        end # @entities loop
        
        # generate changed code
        unless @changes.empty?
          migration_template 'changes_migration.rb', "db/migrate/alter_#{@changes.collect{|c| c[:entity].file_name}.join('_')}#{@random_migration_key}.rb"
          @pending_migrations = true
        end
        
      end
      
      # 
      # Search for many to many tables.
      def many_to_many_tables
        @entities.each do |entity|
          entity.generator_model.associations.select{|a| a.has_and_belongs_to_many?}.each do |association|
            generate "mdwa:association #{association.model1.singular_name} has_and_belongs_to_many #{association.model2.singular_name} --skip-models"
          end
        end
      end
      
      def run_rake_migrate
        rake('db:migrate') if @pending_migrations and yes?('Run rake db:migrate')
      end
      
      def generate_tests
      end
      
      private
        
        def mdwa_template(file_to_read, file_to_write)
          file_path = "#{Rails.root}/#{MDWA::DSL::TEMPLATES_PATH}/#{file_to_read}"
          read = File.read(file_path)
          erb = ERB.new(read, nil, '-')

          create_file "#{Rails.root}/#{file_to_write}", erb.result, :force => true
        end
        
        
        def migration_for_entity(entity)
          # ignores user
          return nil if entity.user?

          generator_model = entity.generator_model

          migration_string = []
          # create table
          migration_string << "\n\tdef self.up"
          migration_string << "\t\tcreate_table :#{generator_model.plural_name} do |t|"
          generator_model.attributes.each do |attr|
          	migration_string << "\t\t\tt.#{attr.migration_field} :#{attr.name}"
        	end
        	generator_model.associations.each do |assoc|
        	  if assoc.belongs_to? or assoc.nested_one?
          	  migration_string << "\t\t\tt.integer :#{assoc.model2.singular_name.foreign_key}"
        	  end
        	end
          migration_string << "\t\t\tt.timestamps"
          migration_string << "\t\tend"
        	generator_model.associations.each do |assoc|
            if assoc.belongs_to? or assoc.nested_one?
          	  migration_string << "\t\tadd_index :#{assoc.model1.plural_name}, :#{assoc.model2.singular_name.foreign_key}"
        	  end
      	  end
          migration_string << "\n\tend"

          # drop table
          migration_string << "\n\tdef self.down"
          migration_string << "\t\tdrop_table :#{generator_model.plural_name}"
          migration_string << "\tend"

          migration_name = "create_#{generator_model.plural_name}"
          migration_from_string(migration_name, migration_string.join("\n"))

          sleep 1 # aguarda 1 seg para trocar o timestamp
          
          @pending_migrations = true
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
        
        def inverse_migration_type(type)
          case type.to_sym
          when :add_column      then 'remove_column'
          when :remove_column   then 'add_column'
          when :change_column   then 'change_column'
          end
        end
        
        # Implement the required interface for Rails::Generators::Migration.
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