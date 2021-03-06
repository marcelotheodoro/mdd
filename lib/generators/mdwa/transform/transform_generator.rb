# -*- encoding : utf-8 -*-

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
      class_option :skip_locales, :type => :boolean, :default => false, :desc => "Skip I18n generation?"
      
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

          #
          # Para cada namespace, gera seu código  
          #
          # Pasta onde o código gerado vai ser colocado
          # Namespace 'frontend' é o público e gera código nas raízes do Rails        
          namespaces = Dir.glob("#{Rails.root}/#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/*").select{|d| File.directory?(d)}.collect {|n| File.basename(n)}
          if !namespaces.count.zero?
            namespaces.each do |namespace|

              namespace_destino = (namespace != 'frontend') ? namespace : ''
              templates_deste_namespace = MDWA::DSL::TEMPLATES_PATH + entity.file_name + '/' + namespace + '/'

              # Gera model, controllers e helper
              mdwa_template "#{entity.file_name}/#{namespace}/model.erb", "app/models/#{namespace_destino}/#{generator_model.singular_name}.rb" if File.exists?(templates_deste_namespace + 'model.erb')
              mdwa_template "#{entity.file_name}/#{namespace}/helper.erb", "app/helpers/#{namespace_destino}/#{generator_model.plural_name}_helper.rb"  if File.exists?(templates_deste_namespace + 'helper.erb')
              mdwa_template "#{entity.file_name}/#{namespace}/controller.erb", "app/controllers/#{namespace_destino}/#{generator_model.plural_name}_controller.rb"  if File.exists?(templates_deste_namespace + 'controller.erb')
              
              # Gera as views
              Dir.glob("#{templates_deste_namespace}/views/*").select{|d| !File.directory?(d)}.each do |file|
                file_name = File.basename(file)
                mdwa_template "#{entity.file_name}/#{namespace}/views/#{file_name}", "app/views/#{namespace_destino}/#{generator_model.plural_name}/#{file_name}"
              end
              # Item de menu
              mdwa_template "#{entity.file_name}/#{namespace}/views/menu/menu.html.erb", "app/views/template/mdwa/menubar/_#{generator_model.plural_name}.html.erb"

            end # nm.each
          end # if nm == 0
        end # each
      end # def

      def create_menu_item
        @entities.each do |entity|
          generator_model = entity.generator_model
          insert_into_file 'app/views/template/mdwa/_menubar.html.erb', before: '</ul>' do
            "  <%= render '/template/mdwa/menubar/#{generator_model.plural_name}' %>\n"
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

        inject_into_file path_to_routes, :after => "def mdwa_router(router)\n" do
  "\n# Software visualization
    namespace :mdwa do
      controller :requirements do
        get 'requirements/index' => 'requirements#index', :as => 'requirements'
        get 'requirements/:alias' => 'requirements#show', :as => 'requirement'
      end
      
      root :to => 'requirements#index'
    end"
        end
        
        MDWA::DSL.entities.all.each do |entity|
          generator_model = entity.generator_model
          
          # inject scaffold code
          inject_into_file path_to_routes, :after => "def mdwa_router(router)\n" do
            route_str = []
            route_str << "\n  namespace :#{generator_model.space} do" if generator_model.namespace?
            route_str << "    controller :#{generator_model.plural_name} do"
            route_str << "      post '#{generator_model.plural_name}/batch_update' => :batch_update, as: :#{generator_model.plural_name}_batch_update"
            route_str << "    end"
            route_str << "    resources :#{generator_model.plural_name}"
            route_str << "  end\n" if generator_model.namespace?
                
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

        return nil if options.skip_locales

        locales_file = 'config/locales/mdwa.specific.en.yml'
        # make sure the file exist
        create_file locales_file unless File.exist?(Rails.root + locales_file)
        locales_content = File.read(locales_file)

        # translated
        if I18n.locale.to_sym != :en
          locales_translated_file = "config/locales/mdwa.specific.#{I18n.locale}.yml"
          create_file locales_translated_file unless File.exist?(Rails.root + locales_translated_file)
          locales_translated_content = File.read(locales_translated_file)
        end
        
        @entities.each do |entity|
          model = entity.generator_model

          lines = []
          lines << "\n"
          lines <<  "  #{model.plural_name}:"
          lines <<  "    notice:"
          lines <<  "      create: \"#{model.singular_name.humanize} created.\""
          lines <<  "      update: \"#{model.singular_name.humanize} updated.\""
          lines <<  "      destroy: \"#{model.singular_name.humanize} destroyed.\""
          lines <<  "      batch_update: \"#{model.singular_name.humanize} updated.\""
          lines <<  "    title:"
          lines <<  "      index: \"#{model.plural_name.humanize}\""
          lines <<  "      show: \"#{model.singular_name.humanize}\""
          lines <<  "      new: \"New #{model.singular_name.humanize}\""
          lines <<  "      edit: \"Edit #{model.singular_name.humanize}\""
          lines <<  "    menu:"
          lines <<  "      index: \"#{model.plural_name.humanize}\""
          lines <<  "      new: \"New #{model.singular_name.humanize}\""
          # Status
          if entity.attributes.select{|name, attr| attr.type.to_sym == :status}.count > 0
            entity.attributes.select{|name, attr| attr.type.to_sym == :status}.each do |name, attr|
              lines <<  "    #{name}:"
              lines <<  "      prompt_select: '- Status -'"
              attr.options[:possible_values].each_with_index do |value, index|
                lines <<  "      #{value.to_s.underscore}: '#{value.to_s.humanize}'"
                lines <<  "      #{value.to_s.underscore}_alter: 'Change #{name} to #{value.to_s.humanize}'"
              end
            end
          end 
          # INDEX
          lines <<  "    index:"
          lines <<  "      add: 'Add'"
          lines <<  "      edit: 'Edit'"
          lines <<  "      edit_label: 'Edit'"
          lines <<  "      remove: 'Remove'"
          lines <<  "      remove_label: 'Remove'"
          lines <<  "      confirm_deletion: 'Are you sure?'"
          model.attributes.each do |attr|
            lines <<  "      #{attr.name}: \"#{attr.name.humanize}\""
          end
          model.associations.each do |assoc|
            lines << ((assoc.belongs_to? or assoc.nested_one? or assoc.has_one?) ? "      #{assoc.model2.singular_name}: \"#{assoc.model2.singular_name.humanize}\"" : "      #{assoc.model2.singular_name}: \"#{assoc.model2.plural_name.humanize}\"")
          end
          # EDIT
          lines <<  "    edit:"
          model.attributes.each do |attr|
            lines <<  "      #{attr.name}: \"#{attr.name.humanize}\""
          end
          model.associations.each do |assoc|
            lines << ((assoc.belongs_to? or assoc.nested_one? or assoc.has_one?) ? "      #{assoc.model2.singular_name}: \"#{assoc.model2.singular_name.humanize}\"" : "      #{assoc.model2.singular_name}: \"#{assoc.model2.plural_name.humanize}\"")
          end
          # SHOW
          lines <<  "    show:"
          model.attributes.each do |attr|
            lines <<  "      #{attr.name}: \"#{attr.name.humanize}\""
          end
          model.associations.each do |assoc|
            lines << ((assoc.belongs_to? or assoc.nested_one? or assoc.has_one?) ? "      #{assoc.model2.singular_name}: \"#{assoc.model2.singular_name.humanize}\"" : "      #{assoc.model2.singular_name}: \"#{assoc.model2.plural_name.humanize}\"")
          end
          lines << "\n"

          if !locales_content.include?( "  #{model.plural_name}:" )
            append_file locales_file, lines.join("\n"), :after => "en:"
          end

          if I18n.locale.to_sym != :en and !locales_translated_content.include?( "  #{model.plural_name}:" )
            append_file locales_translated_file, lines.join("\n"), :after => "#{I18n.locale}:"
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
            next if column.name.end_with? '_id'
                        
            entity_attribute = entity.attributes[column.name]
            # model attribute exists, but not in entity -> was erased
            if entity_attribute.nil?
              # atributo não é derivado de file, pode apagar na moral
              if !column.name.ends_with?("_file_name") and !column.name.ends_with?("_content_type") and !column.name.ends_with?("_file_size") and !column.name.ends_with?("_updated_at") 
                @changes << {:entity => entity, :type => 'remove_column', :column => column.name, :attr_type => column.type}
              else
                # se o atributo é derivado de file e não existe o file na entidade, apaga
                @changes << {:entity => entity, :type => 'remove_column', :column => column.name, :attr_type => column.type} if column.name.ends_with?("_file_name") and entity.attributes[column.name.gsub("_file_name", '')].nil?
                @changes << {:entity => entity, :type => 'remove_column', :column => column.name, :attr_type => column.type} if column.name.ends_with?("_content_type") and entity.attributes[column.name.gsub("_content_type", '')].nil?
                @changes << {:entity => entity, :type => 'remove_column', :column => column.name, :attr_type => column.type} if column.name.ends_with?("_file_size") and entity.attributes[column.name.gsub("_file_size", '')].nil?
                @changes << {:entity => entity, :type => 'remove_column', :column => column.name, :attr_type => column.type} if column.name.ends_with?("_updated_at") and entity.attributes[column.name.gsub("_updated_at", '')].nil?
              end
            # attribute exists in model and entity, but changed type
            elsif entity_attribute.type.to_sym != column.type.to_sym
              # ignores files, passwords and float, decimal, integer variations
              next if entity_attribute.type.to_sym == :password or (entity_attribute.type.to_sym == :status and column.type.to_sym == :integer) or ((column.type.to_sym == :integer or column.type.to_sym == :decimal) and entity_attribute.type.to_sym == :float)
              @changes << {:entity => entity, :type => 'change_column', :column => column.name, :attr_type => entity_attribute.type, :from => column.type}
            end
          end
          
          # new attributes
          # no column with that name -> column must be added
          entity.attributes.each do |key, attr|
            # se o atributo for file e não existir seus atributos no banco de dados, corrige
            if attr.type.to_sym == :file
              @changes << {:entity => entity, :type => 'add_column', :column => "#{attr.name}_file_name", :attr_type => 'string'} if model_class.columns.select{|c| c.name == "#{attr.name}_file_name"}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => "#{attr.name}_content_type", :attr_type => 'string'} if model_class.columns.select{|c| c.name == "#{attr.name}_content_type"}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => "#{attr.name}_file_size", :attr_type => 'integer'} if model_class.columns.select{|c| c.name == "#{attr.name}_file_size"}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => "#{attr.name}_updated_at", :attr_type => 'datetime'} if model_class.columns.select{|c| c.name == "#{attr.name}_updated_at"}.count.zero?
            
            # nenhuma coluna com esse nome
            elsif model_class.columns.select {|c| c.name == attr.name }.count.zero?
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
        rake('db:migrate') if @pending_migrations and yes?('Run rake db:migrate?')
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
          generator_model.attributes.select{|a| !['id', 'created_at', 'updated_at'].include?(a.name)}.each do |attr|
            if attr.name.to_sym == :removed
              migration_string << "\t\t\tt.#{attr.migration_field} :#{attr.name}, default: false"
            else
              migration_string << "\t\t\tt.#{attr.migration_field} :#{attr.name}"
            end
        	end
        	generator_model.associations.each do |assoc|
        	  if assoc.belongs_to? or assoc.nested_one?
          	  migration_string << "\t\t\tt.integer :#{assoc.model2.singular_name.foreign_key}"
        	  end
        	end
          migration_string << "\n\t\t\tt.timestamps"
          migration_string << "\t\tend" # fim do create_table
        	generator_model.associations.each do |assoc|
            if assoc.belongs_to? or assoc.nested_one?
          	  migration_string << "\t\tadd_index :#{assoc.model1.plural_name}, :#{assoc.model2.singular_name.foreign_key}"
        	  end
      	  end
          migration_string << "\n\tend" # fim do self.up

          # drop table
          migration_string << "\n\tdef self.down"
          migration_string << "\t\tdrop_table :#{generator_model.plural_name}"
          migration_string << "\tend"

          sleep 1 # aguarda 1 seg para trocar o timestamp
          migration_name = "create_#{generator_model.plural_name}"
          migration_from_string(migration_name, migration_string.join("\n"))
          
          @pending_migrations = true
        end
        
        def migration_from_string(file_name, migration_string)
          
          # migration number
          if ActiveRecord::Base.timestamped_migrations
            @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S")
            sleep 1
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
