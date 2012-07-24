# -*- encoding : utf-8 -*-
require 'rails/generators/migration'
require 'mdwa/dsl'

module Mdwa
  module Generators

    class UserGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)
      
      attr_accessor :user
      
      argument :user_name

      def initialize(*args, &block)
        super
        
        @user = user_name.singularize.camelize
      end
    
      def generate_user
        template 'user.rb', "#{MDWA::DSL::USERS_PATH}#{@user.underscore}.rb"
        generate "mdwa:entity #{@user} --user"
      end

    end # class user generator

  end # generators
end # mdwa
