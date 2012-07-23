# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class Requirement
      
      attr_accessor :summary, :description, :alias, :users, :entities
      
      def initialize(summary = nil)
        self.summary  = summary
        
        self.users    = []
        self.entities = []
      end
      
      def alias
        @alias ||= self.summary.gsub(' ', '_').underscore
      end
      
    end
    
  end # dsl
end # mdwa