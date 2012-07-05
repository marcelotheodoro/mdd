# -*- encoding : utf-8 -*-
require 'ostruct'

module MDD
  module DSL

    class Entity
      
      attr_accessor :name, :resource, :model_name, :ajax
      attr_accessor :attributes, :associations
      
      def initialize( name )
        # set the entity name
        self.name = name
        
        # fixed attributes
        resource    = false
        model_name  = self.name
        ajax        = false
        
        # arrays
        attributes   = []
        associations = []
      end
      
      def generate
        
      end
      
    end

  end
end