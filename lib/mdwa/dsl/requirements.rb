# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    # singleton class
    class Requirements
      
      attr_accessor :nodes
      
      def initialize
        @nodes ||= {}
      end
      
      def self.instance
        @__instance__ ||= new
      end
      
      #
      # Register a new requirement in the list.
      #
      def register( summary = nil )
        # retrive or initialize a entity
        req = Requirement.new( summary )
        yield(req) if block_given?
        add_node(req) # add to the list
      end
    
      #
      # Add note to the entity list
      # Prevents entity duplication
      #
      def add_node(node)
        @nodes[node.alias] = node
      end
      
      def element(e)
        @nodes[e]
      end
      
      def all
        @nodes.values
      end

    end # class
    
    # return the requirements instance
    def self.requirements
      Requirements.instance
    end
    
    def self.requirement(name)
      self.requirements.element(name)
    end

    
  end # dsl
end # mdd
