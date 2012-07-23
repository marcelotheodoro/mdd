# -*- encoding : utf-8 -*-

require 'rails/generators'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class EntityGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      argument :name, :type => :string, :banner => 'Entity name'
      
      class_option :user, :type => :boolean, :default => false, :desc => 'Is this entity a loggable user?'
      class_option :no_comments, :type => :boolean, :default => false, :desc => 'Generates entity without comments.'
      
      def code_generation
        template 'entity.rb', "#{MDWA::DSL::STRUCTURAL_PATH}#{MDWA::DSL::Entity.new(name).file_name}.rb"
      end
      
    end # entity
  end #generators
end #mdwa