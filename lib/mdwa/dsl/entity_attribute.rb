# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class EntityAttribute
      
      attr_accessor :entity, :name, :type, :default
      
      def initialize(entity)
        self.entity = entity
        self.default = false
      end
      
      def valid?
        !entity.nil? and !name.blank? and !type.blank?
      end
      
      def default?
        self.default
      end
      
    end
    
  end
end