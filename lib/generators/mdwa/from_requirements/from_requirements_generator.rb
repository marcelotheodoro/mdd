# -*- encoding : utf-8 -*-

require 'rails/generators'

require 'mdwa/dsl'

module Mdwa
  module Generators
    
    class FromRequirementsGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)
      attr_accessor :requirements
      
      #
      # Constructor
      # Require all entities to load the DSL of the application
      #
      def initialize(*args, &block)
        super
        
        # include files with requirements
        inside Rails.root do
          require_all MDWA::DSL::REQUIREMENTS_PATH
        end
        @requirements = MDWA::DSL.requirements.all

      end
      
      
      #
      # Generate code for requirements.
      # Generate files for entities and users.
      def requirements
        
        # For all requirements, generate users and entities
        @requirements.each do |requirement|
          
          # generate entities
          requirement.entities.each do |entity|
            inside Rails.root do 
              generate "mdwa:entity #{entity}" unless File.exist?("#{MDWA::DSL::STRUCTURAL_PATH}#{entity}")
            end
          end
          
          # generate users
          requirement.users.each do |user|
            generate "mdwa:user #{user}" unless File.exist?("#{MDWA::DSL::STRUCTURAL_PATH}#{entity}")
          end
          
        end
        
      end
      
    end # class
    
  end # generators
end # mdwa