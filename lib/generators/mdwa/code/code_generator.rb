# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class CodeGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)
      
      attr_accessor :all_entities, :code_changes, :random_migration_key

      argument :entities, :type => :array, :banner => 'Specific entities', :default => []
      
      class_option :run_migrations, :type => :boolean, :default => false, :desc => 'Run rake db:migrate directly'
      class_option :only_interface, :type => :boolean, :default => false, :desc => 'Generate only user interface'
      
      #
      # Constructor
      # Require all entities to load the DSL of the application
      #
      def initialize(*args, &block)
        super
        
        # include files with entities
        # select models that will be generated
        # only required models are included
        inside Rails.root do
          if entities.count.zero?
            require_all MDWA::DSL::STRUCTURAL_PATH
          else
            files = entities.collect{ |e| "#{MDWA::DSL::STRUCTURAL_PATH}#{MDWA::DSL::Entity.new(e).file_name}.rb" }
            require_all files.join(', ')
          end
        end
        @all_entities = MDWA::DSL.entities.all
        
        # entity changes and migrations
        @changes = []
        @random_migration_key = rand.to_s.gsub('.','').to_i
        
      end
      
      
      #
      # Generate code for entities or entity changes.
      # Generate migration for field changes.
      #
      def entities_and_changes
        
        return false if options.only_interface
        
        @all_entities.each do |entity|
          
          # if it's not a resource, ignore
          next unless entity.resource?
          
          # if model has not a database yet, run the generate command
          begin
            # if model does not exist, should generate scaffold
            model_class = entity.model_class
          rescue
            model_class = nil
          end
          if entity.force? or model_class.nil? or !model_class.table_exists?
            puts "===================================================="
            puts "Generating code for '#{entity.name}'"
            puts "===================================================="
            generation_string = "#{entity.generate} #{'--skip_rake_migrate' unless options.run_migrations} #{'--force' if options.force} --skip-questions"
            generate generation_string
            
            # append generated code to entity
            append_to_file "#{MDWA::DSL::STRUCTURAL_PATH}#{entity.file_name}.rb", "\n\nMDWA::DSL.entity('#{entity.name}').code_generations << '#{generation_string}'"
            
            next # nothing's changed, go to the next entity
          end
          
          next if entity.user?
        
          # check what changed
          model_class.columns.each do |column|
            # ignore rails default columns and attributes used in associations
            next if column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at' or column.name.end_with? '_id'
            
            entity_attribute = entity.attributes[column.name]
            # model attribute exists, but not in entity -> was erased
            if entity_attribute.nil?
              @changes << {:entity => entity, :type => 'remove_column', :column => column.name}
            # attribute exists in model and entity, but changed type
            elsif entity_attribute.type.to_sym != column.type.to_sym
              next if entity_attribute.type.to_sym == :file or entity_attribute.type.to_sym == :password
              @changes << {:entity => entity, :type => 'change_column', :column => column.name, :attr_type => entity_attribute.type, :from => column.type}
            end
            
          end
          
          # new attributes
          entity.attributes.each do |key, attr|
            # no column with that name -> column must be added
            if model_class.columns.select {|c| c.name == attr.name}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => attr.name, :attr_type => attr.type}
            end
          end
          
        end
        
        # generate changed code
        unless @changes.empty?
          migration_template 'migration.rb', "db/migrate/alter_#{@all_entities.select{|e| e.resource?}.collect{|e| e.file_name}.join('_')}#{@random_migration_key}.rb"
        end
        
      end
      
      
      #
      # Generate entities interface.
      #
      def entities_interface
        
        if options.only_interface
          @all_entities.each do |entity|

            # if it's not a resource, ignore
            next unless entity.resource?

            # if model has not a database yet, run the generate command
            begin
              # if model does not exist, should generate scaffold
              model_class = entity.model_class
            rescue
              model_class = nil
            end
            if entity.force? or model_class.nil? or !model_class.table_exists?
              puts "===================================================="
              puts "Generating code for '#{entity.name}'"
              puts "===================================================="
              generate "#{entity.generate} --only_interface #{'--force' if options.force}"
              
              # append generated code to entity
              append_to_file "#{MDWA::DSL::STRUCTURAL_PATH}#{entity.file_name}.rb", "\n\nMDWA::DSL.entity('#{entity.name}').code_generations << '#{generation_string}'"
            end
          end
        end
        
      end 
      
      
      #
      # Generate actions for entities.
      #
      def entities_actions
      end 
      
      #
      # Generate code for entities specify.
      #
      def entites_specifications
      end
    
      
      #
      # Run rake db:migrate
      #
      def rake_db_migrate
        if options.run_migrations
          rake 'db:migrate'
        end
      end

      
      
      
      
      private 
      
       # Implement the required interface for Rails::Generators::Migration.
       def self.next_migration_number(dirname) #:nodoc:
         if ActiveRecord::Base.timestamped_migrations
           Time.now.utc.strftime("%Y%m%d%H%M%S")
         else
           "%.3d" % (current_migration_number(dirname) + 1)
         end
       end
      
       def inverse_migration_type(type)
         case type.to_sym
         when :add_column      then 'remove_column'
         when :remove_column   then 'add_column'
         when :change_column   then 'change_column'
         end
       end
      
    end # class
  end # generators
end # mdwa
    