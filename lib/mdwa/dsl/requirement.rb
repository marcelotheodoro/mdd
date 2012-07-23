# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class Requirement
      
      attr_accessor :summary, :description
      
      def initialize(summary = nil)
        self.summary = summary
      end
      
      def alias
        self.summary.gsub(' ', '_').underscore
      end
      
    end
    
  end # dsl
end # mdwa