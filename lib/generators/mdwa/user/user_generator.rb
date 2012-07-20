require 'rails/generators/migration'
require 'mdwa/generators'

module Mdwa
  
  module Generators

    class UserGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)
      
      argument :user_name

      def initialize(*args, &block)
        super
      end

    end

  end 
end