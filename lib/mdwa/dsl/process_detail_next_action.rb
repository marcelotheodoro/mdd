# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class ProcessDetailNextAction
      
      attr_accessor :alias, :method, :request, :redirect, :render, :when
      
      def initialize(next_action_alias)
        self.alias = next_action_alias
      end
      
    end
    
  end # dsl
end # mdwa