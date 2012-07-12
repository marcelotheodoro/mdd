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
      
      def initialize(*args, &block)
        super
        
        # include files with entities
        inside Rails.root do
          if entities.count.zero?
            require_all MDWA::DSL::STRUCTURAL_PATH
          else
            files = entities.collect{ |e| "#{MDWA::DSL::STRUCTURAL_PATH}#{MDWA::DSL::Entity.new(e).file_name}.rb" }
            require_all files.join(', ')
          end
        end
        
        # select models that will be generated
        # only required models are included
        @all_entities = MDWA::DSL.entities.all
        
        @changes = []
        @random_migration_key = rand.to_s.gsub('.','').to_i
        
      end
      
      def code_generation
        
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
          if model_class.nil? or !model_class.table_exists?
            puts "===================================================="
            puts "Generating code for '#{entity.name}'"
            puts "===================================================="
            generate "#{entity.generate} #{'--skip_rake_migrate' unless options.run_migrations}"
            next # nothing's changed, go to the next entity
          end
        
          # check what changed
          model_class.columns.each do |column|
            # ignore rails default columns
            next if column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at'
            
            entity_attribute = entity.attributes[column.name]
            # model attribute exists, but not in entity -> was erased
            if entity_attribute.nil? 
              @changes << {:entity => entity, :type => 'remove_column', :column => column.name}
              # puts "#{entity.name} - #{column.name}: Atributo apagado"
            # attribute exists in model and entity, but changed type
            elsif entity_attribute.type.to_sym != column.type.to_sym 
              @changes << {:entity => entity, :type => 'change_column', :column => column.name, :attr_type => entity_attribute.type, :from => column.type}
              # puts "#{entity.name} - #{column.name}: Trocou de #{entity_attribute.type} por #{column.type}"
            end
            
          end
          
          # new attributes
          entity.attributes.each do |key, attr|
            # no column with that name -> column must be added
            if model_class.columns.select {|c| c.name == attr.name}.count.zero?
              @changes << {:entity => entity, :type => 'add_column', :column => attr.name, :attr_type => attr.type}
              # puts "#{entity.name} - #{attr.name}: Atributo a incluir"
            end
          end
          
        end
        
      end  
      
      def migration_generation
        unless @changes.empty?
          # generate changed code                                                               
          migration_template 'migration.rb', "db/migrate/alter_#{@all_entities.select{|e| e.resource?}.collect{|e| e.file_name}.join('_')}#{@random_migration_key}.rb"
        end
      end
      
      def rake_db_migrate
        if options.run_migrations
          rake 'db:migrate'
        end
      end
      
      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S").to_s
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end   
      
      private 
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
    