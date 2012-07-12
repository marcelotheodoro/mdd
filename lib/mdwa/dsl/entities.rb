# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    # singleton class
    class Entities
      
      attr_accessor :nodes
      
      def initialize
        @nodes ||= {}
      end
      
      def self.instance
        @__instance__ ||= new
      end
      
      #
      # Register a new entity in the list.
      #
      def register( name )
        # retrive or initialize a entity
        e = element(name) || Entity.new( name )
        yield e
        add_node e # add to the list
      end
    
      #
      # Add note to the entity list
      # Prevents entity duplication
      #
      def add_node(node)
        @nodes[node.name] = node
      end
      
      def element(e)
        @nodes[e]
      end
      
      def all
        @nodes.values
      end

    end # class entitites
    
    # return the entities instance
    def self.entities
      Entities.instance
    end
    
    def self.entity(name)
      self.entities.element(name)
    end

    
  end # dsl
end # mdd