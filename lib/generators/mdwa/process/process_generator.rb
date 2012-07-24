# -*- encoding : utf-8 -*-

require 'rails/generators'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class ProcessGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      argument :description, :type => :string, :banner => 'Process description'
      
      class_option :no_comments, :type => :boolean, :default => false, :desc => 'Generates process without comments.'
      
      def code_generation
        @process = MDWA::DSL::Process.new(description)
        template 'requirement.rb', "#{MDWA::DSL::WORKFLOW_PATH}#{@process.alias}.rb"
      end
      
    end # entity
  end # generators
end # mdwa