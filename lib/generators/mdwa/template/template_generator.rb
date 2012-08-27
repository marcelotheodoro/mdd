# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class CodeGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)
      
      attr_accessor :entities
      
      #
      # Constructor
      # Require all entities to load the DSL of the application
      def initialize(*args, &block)
        super
        
        # include files with entities
        # select entities that will be generated
        inside Rails.root do
          require_all MDWA::DSL::STRUCTURAL_PATH unless Dir.glob("#{MDWA::DSL::STRUCTURAL_PATH}/*.rb").count.zero?
        end
        @entities = MDWA::DSL.entities.all
      end
      
      
      def general_files
        template 'general/routes.rb', "#{MDWA::DSL::TEMPLATES_PATH}routes.rb"
      end
      
      def entities_scaffold
        
        @entities.each do |entity|
          copy_with_header 'scaffold/controller.rb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/controller.rb", entity.name
          copy_with_header 'scaffold/helper.rb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/helper.rb", entity.name
          copy_with_header 'scaffold/model.rb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/model.rb", entity.name
          
          # views
          copy_with_header 'scaffold/views/_form_fields.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/_form_fields.html.erb", entity.name
          copy_with_header 'scaffold/views/_form.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/_form.html.erb", entity.name
          copy_with_header 'scaffold/views/_list.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/_list.html.erb", entity.name
          copy_with_header 'scaffold/views/create.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/create.js.erb", entity.name
          copy_with_header 'scaffold/views/destroy.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/destroy.js.erb", entity.name
          copy_with_header 'scaffold/views/edit.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/edit.html.erb", entity.name
          copy_with_header 'scaffold/views/index.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/index.html.erb", entity.name
          copy_with_header 'scaffold/views/index.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/index.js.erb", entity.name
          copy_with_header 'scaffold/views/new.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/new.html.erb", entity.name
          copy_with_header 'scaffold/views/show.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/show.html.erb", entity.name
          copy_with_header 'scaffold/views/update.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/update.js.erb", entity.name
        end
        
      end
      
      
      private
      
        def copy_with_header(source, destination, entity)
          copy_file source, destination
          insert_into_file destination do
            "<%- @entity = MDWA::DSL.entity('#{entity}') \n@model = @entity.generator_model \n-%>"
          end
        end
      
    end
  end
end