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
        @project_entity = MDWA::DSL.entity('Project')
        
        model = File.read("#{Rails.root}/#{MDWA::DSL::TEMPLATES_PATH}#{@project_entity.file_name}/model.rb")
        model_erb = ERB.new(model, nil, '-')
        puts model_erb.result
      end
      
    end
    
  end
end