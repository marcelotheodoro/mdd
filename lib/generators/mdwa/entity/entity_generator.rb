# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

module Mdwa
  module Generators
    class EntityGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      argument :name, :type => :string, :banner => 'Entity name'
      
      def generate
        template 'entity.rb', "app/mdwa/entities/#{name}.rb"
      end
      
    end # entity
  end #generators
end #mdwa