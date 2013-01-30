# -*- encoding : utf-8 -*-
require 'extensions/string'

module MDWA
  module DSL
    
    class Requirement
      
      attr_accessor :summary, :description, :alias, :users, :entities, :non_functional_description
      
      def initialize(summary = nil)
        self.summary  = summary
        
        self.users    = []
        self.entities = []
      end

      def summary=(summary)
        @summary = summary
        @alias = summary.to_alias unless summary.nil?
      end
      
      def non_functional?
        !self.non_functional_description.blank?
      end
      
    end
    
  end # dsl
end # mdwa
