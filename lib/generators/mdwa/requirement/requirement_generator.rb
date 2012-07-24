# -*- encoding : utf-8 -*-

require 'rails/generators'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class RequirementGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      argument :summary, :type => :string, :banner => 'Requirement summary'
      
      class_option :no_comments, :type => :boolean, :default => false, :desc => 'Generates requirements without comments.'
      
      def code_generation
        @requirement = MDWA::DSL::Requirement.new(summary)
        template 'requirement.rb', "#{MDWA::DSL::REQUIREMENTS_PATH}#{@requirement.alias}.rb"
      end
      
    end # entity
  end # generators
end # mdwa
