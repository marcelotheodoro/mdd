# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class ProcessDetailNextAction
      
      attr_accessor :parent, :next_action, :method, :request, :redirect, :render, :when
      
      def initialize(parent, next_action)
        self.parent = parent
        self.next_action = next_action
      end
      
    end
    
  end # dsl
end # mdwa