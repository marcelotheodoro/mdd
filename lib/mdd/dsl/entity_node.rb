# -*- encoding : utf-8 -*-
require 'ostruct'

module MDD
  module DSL

    class EntityNode
      
      attr_accessor :name, :resource
      
      def initialize( name )
        self.name = name
      end
      
      def generate
        
      end
      
    end

  end
end