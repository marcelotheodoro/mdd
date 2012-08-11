# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class CodeGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)
      
      argument :entities, :type => :array, :banner => 'Specific entities', :default => []
      
      #
      # Constructor
      # Require all entities to load the DSL of the application
      def initialize(*args, &block)
        super
        
        # include files with entities
        # select entities that will be generated
        inside Rails.root do
          if entities.count.zero?
            require_all MDWA::DSL::STRUCTURAL_PATH unless Dir.glob("#{MDWA::DSL::STRUCTURAL_PATH}/*.rb").count.zero?
          else
            files = entities.collect{ |e| "#{MDWA::DSL::STRUCTURAL_PATH}#{MDWA::DSL::Entity.new(e).file_name}.rb" }
            require_all files.join(', ')
          end
        end
        @all_entities = MDWA::DSL.entities.all
      end
      
      
    end
  end
end