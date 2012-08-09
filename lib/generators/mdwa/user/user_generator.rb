# -*- encoding : utf-8 -*-
require 'rails/generators/migration'
require 'mdwa/dsl'

module Mdwa
  module Generators

    class UserGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)
      
      attr_accessor :user
      
      argument :user_name
      
      class_option :requirement, :type => :string, :desc => 'Requirement alias'

      def initialize(*args, &block)
        super
        @user = user_name.singularize.camelize
      end
    
      def generate_user
        file_name = "#{MDWA::DSL::USERS_PATH}#{@user.underscore}.rb"
        # if file doesn't exist, create it
        # if file exists, include the in_requirements clause
        if !File.exist?( Rails.root + file_name )
          template 'user.rb', file_name
        else
          append_to_file( file_name, "\nMDWA::DSL.user('#{@user}').in_requirements << '#{options.requirement}'" ) unless options.requirement.blank?
        end
        
        generate "mdwa:entity #{@user} --user --requirement=\"#{options.requirement}\""
      end

    end # class user generator

  end # generators
end # mdwa
