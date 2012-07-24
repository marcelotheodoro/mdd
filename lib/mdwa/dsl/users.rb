# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    # singleton class
    class Users
      
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
        user = element(name) || User.new( name )
        yield(user) if block_given?
        add_node user # add to the list
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
    def self.users
      Users.instance
    end
    
    def self.user(name)
      self.users.element(name)
    end

    
  end # dsl
end # mdd
