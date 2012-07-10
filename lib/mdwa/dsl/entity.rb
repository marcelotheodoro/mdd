# -*- encoding : utf-8 -*-
require 'ostruct'

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
        self.attributes   = []
        self.associations = []
      end
      
      def attribute
        attr = OpenStruct.new
        yield( attr ) if block_given?
        self.attributes << attr
      end
      
      def generate
        
      end
      
    end

  end
end