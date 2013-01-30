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
      class_option :requirement, :type => :string, :desc => 'Requirement alias'
      
      def code_generation
        file_name = "#{MDWA::DSL::STRUCTURAL_PATH}#{MDWA::DSL::Entity.new(name).file_name}.rb"
        # if file doesn't exist, create it
        # if file exists, include the in_requirements clause
        if !File.exist?( Rails.root + file_name )
          template 'entity.rb', file_name
        else
          append_to_file( file_name, "\nMDWA::DSL.entity('#{name.singularize.camelize}').in_requirements << '#{options.requirement}'" ) unless options.requirement.blank?
        end
      end
      
    end # entity
  end #generators
end #mdwa
