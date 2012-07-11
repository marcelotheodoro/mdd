# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class Entity
      
      attr_accessor :name, :resource, :purpose, :model_name, :ajax, :generated, :force
      attr_accessor :attributes, :associations
      
      def initialize( name )
        # set the entity name
        self.name = name
        
        # fixed attributes
        self.resource    = false
        self.model_name  = self.name
        self.ajax        = false
        self.generated   = false
        self.force       = false
        
        # arrays
        self.attributes   = {}
        self.associations = {}
      end
      
      def attribute
        attr = EntityAttribute.new(self)
        yield( attr ) if block_given?
        self.attributes[attr.name] = attr
      end
      
      def default_attribute
        default_attr = self.attributes.first.last # first element value
        self.attributes.each do |key, attr|
          default_attr = attr if attr.default?
        end
        return default_attr
      end
      
      def generate
        
      end
      
    end

  end
end