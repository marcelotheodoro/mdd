# -*- encoding : utf-8 -*-
require 'ostruct'
module MDWA
  module DSL
    
    class ProcessDetail
      attr_accessor :process, :description, :alias, :user_roles, :detail_action, :next_actions
      
      def initialize(process, description)
        self.process      = process
        self.description  = description
        
        self.user_roles   = []
        self.next_actions = {}
        self.detail_action = OpenStruct.new
      end
      
      # Unique alias for detailing
      # Default: Detail name underscored
      def alias
        @alias ||= self.description.gsub(' ', '_').underscore
      end
      
      # Refered action
      # Params: 
      # => :entity
      # => :action
      def action(entity, action)
        self.detail_action.entity = entity
        self.detail_action.action = action
      end
      
      # Possible next action
      # Params: 
      # => :alias
      # => :entity
      # => :action
      # => :method
      # => :request
      # => :redirect  => boolean
      # => :render    => boolean
      # => :when - situation when it might occur
      def next_action(detail_alias = nil, options = {})
        action = self.process.process_detail(:alias => detail_alias, :entity => options[:entity], :action => options[:action])

        next_action = ProcessDetailNextAction.new(self, action)
        next_action.method    = options[:method]
        next_action.request   = options[:request]
        next_action.redirect  = options[:redirect]
        next_action.render    = options[:render]
        next_action.when      = options[:when]

        next_actions[next_action.alias] = next_action
      end
            
    end
    
  end # dsl
end # mdwa
