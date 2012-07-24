# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class Process
      attr_accessor :description, :alias
      
      def initialize(description) 
        self.description = description
      end
      
      def alias
        @alias ||= self.summary.gsub(' ', '_').underscore
      end
      
    end
    
  end # dsl
end # mdwa