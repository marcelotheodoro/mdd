# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class EntityAssociation
      
      attr_accessor :source, :destination, :destination_view
      attr_accessor :name, :type, :composition, :description
      
      ACCEPTED_TYPES = [:one_to_many, :many_to_one, :one_to_one, :one_to_one_not_navigable, :many_to_many]
      
      def initialize(source)
        self.source = source
        self.composition = false
      end
      
      #
      # Sets the destination entity.
      # Sets the name if not set yet.
      # 
      def destination=(value)
        self.name = value.downcase if self.name.blank?
        @destination = value
      end
      
      #
      # Return the mapped type for the code generation.
      #
      def generator_type
        case self.type.to_sym
          when :many_to_one
            return (self.composition ? 'nested_many' : 'has_many' )
          when :one_to_one
            return (self.composition ? 'nested_one' : 'belongs_to' )
          when :one_to_one_not_navigable
            'has_one'
          when :one_to_many
            'belongs_to'
          when :many_to_many
            'has_and_belongs_to_many'
          end
      end
      
      def generate
        destination = DSL.entity(self.destination.camelize)
        
        gen = []
        gen << self.name
        gen << destination.scaffold_name
        gen << ",#{destination.model_name}" unless destination.model_name != destination.scaffold_name
        gen << (self.destination_view || destination.default_attribute.name)
        gen << generator_type
        
        gen.join(':')
      end
      
    end
    
  end
end