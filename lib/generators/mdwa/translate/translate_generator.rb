# -*- encoding : utf-8 -*-

require 'rails/generators'

require 'mdwa/dsl'

module Mdwa
  module Generators
    
    class TranslateGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)
      attr_accessor :requirements
      
      argument :language, :type => :string, :banner => 'The target language you want to translate', :default => 'br'
      
      def br
        return false unless language.to_sym == :br
        
        language_suffix = 'pt-BR'
        copy_file "br/config/initializers/inflections.rb", 'config/initializers/inflections.rb'
        copy_file "br/config/locales/devise.#{language_suffix}.yml", 'config/locales/devise.#{language_suffix}.yml'
        copy_file "br/config/locales/mdwa.#{language_suffix}.yml", 'config/locales/mdwa.#{language_suffix}.yml'

        application "config.time_zone = 'Brasilia'"
        application "config.i18n.default_locale = 'pt-BR'"

        puts '-----------------------------------------------------------------------'
        puts 'Make sure to restart the server in order to update the configurations'
        puts '-----------------------------------------------------------------------'

      end
      
    end # class
    
  end # generators
end # mdwa
