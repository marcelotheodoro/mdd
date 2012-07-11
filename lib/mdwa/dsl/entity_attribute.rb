# -*- encoding : utf-8 -*-
require 'mdwa/generators'

module MDWA
  module DSL

    class EntityAttribute
      
      attr_accessor :entity, :name, :type, :default
      
      ACCEPTED_TYPES = MDWA::Generators::ModelAttribute::STATIC_TYPES
      
      def initialize(entity)
        self.entity = entity
        self.default = false
      end
      
      def raise_errors_if_invalid!
        if !valid?
          raise "Invalid entity attribute: name is blank" if self.name.blank?
          raise "Invalid entity attribute: '#{name}' - type is blank" if self.type.blank?
          raise "Invalid entity attribute: '#{name}' - type '#{type}' is invalid" if self.type_invalid?
          raise "Invalid entity attribute: '#{name}' - entity is nil" if self.entity.blank?
        end
      end
      
      def valid?
        !entity.nil? and !name.blank? and !type.blank? and !type_invalid?
      end
      
      def type_invalid?
        !ACCEPTED_TYPES.include?( self.type.to_sym )
      end
      
      def default?
        self.default
      end
      
      def generate
        "#{name}:#{type}"
      end
      
    end
    
  end
end