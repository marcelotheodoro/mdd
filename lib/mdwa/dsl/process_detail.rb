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
        self.next_actions = []
        self.detail_action = OpenStruct.new
      end
      
      # Unique alias for detailing
      # Default: Detail name underscored
      def alias
        @alias ||= self.description.to_alias
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
      def next_action(detail_alias, options = {})
        next_action = ProcessDetailNextAction.new(detail_alias)
        next_action.method    = options[:method] || :get
        next_action.request   = options[:request] || :html
        next_action.redirect  = options[:redirect] || false
        next_action.render    = options[:render] || false
        next_action.when      = options[:when]

        next_actions << next_action
      end
            
    end
    
  end # dsl
end # mdwa
