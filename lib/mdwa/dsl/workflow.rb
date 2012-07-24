# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    # singleton class
    class Workflow
      
      attr_accessor :nodes
      
      def initialize
        @nodes ||= {}
      end
      
      def self.instance
        @__instance__ ||= new
      end
      
      #
      # Register a new user in the list.
      #
      def register( name )
        # retrive or initialize a entity
        process = element(name) || Process.new( name )
        yield(process) if block_given?
        add_node process # add to the list
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

    end # class entitites
    
    # return the entities instance
    def self.workflow
      Workflow.instance
    end
    
    def self.process(name)
      self.workflow.element(name)
    end

    
  end # dsl
end # mdd
