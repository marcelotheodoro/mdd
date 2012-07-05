# -*- encoding : utf-8 -*-
module MDD
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
      
      def register( name )        
        e = Entity.new( name )
        yield e
        add_node e
      end
    
      def add_node(node)
        @nodes[node.name] = node
      end
      
      def element(e)
        @nodes[e]
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