# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class Action
      
      ACTION_TYPES    = [:collection, :member]
      ALLOWED_METHODS = [:get, :post, :put, :delete]
      PREDEFINED_REQUEST_TYPES   = [:html, :ajax, :ajax_js, :modalbox]
      
      attr_accessor :name, :type, :method, :request_type, :resource
      
      def initialize(name, type, options = {})
        self.name         = name.to_sym
        self.type         = type.to_sym
        self.method       = options[:method] || :get
        self.request_type = options[:request_type] || :html
        self.response     = options[:response] || {}
        self.resource     = options[:resource] || false
      end
      
      def request_type=(value)
        if value.is_a? Array
          @request_type = value
        else
          @request_type = [value] 
        end
      end
      
      def response=(value)
        if value.is_a? Hash
          @request_type = value
        else
          @request_type = {self.method.first.to_sym => value}
        end
      end
      
      def member?
        self.method.to_sym == :member
      end
      
      def collection?
        self.method.to_sym == :collection
      end
      
      def resource?
        resource
      end
      
      def generate_controller
        action_str = []
        action_str << "def #{action.name.to_s}"
        action_str << ""
          action_str << "\trespond_to do |format|"        
          self.request_type.each do |request|          
            case request.to_sym
            when :modalbox
              action_str << "\tformat.html{render :layout => false}"
            when :html
              action_str << "\t\tformat.html #{"{#{options.response[:html]}}" unless options.response[:html].blank?}"
            when :ajax
              action_str << "\t\tformat.js #{"{#{options.response[:ajax]}}" unless options.response[:ajax].blank?}"
            when :ajax_js
              action_str << "\t\tformat.json #{"{#{options.response[:ajax_js]}}" unless options.response[:ajax_js].blank?}"
            else
              action_str << "\t\tformat.#{request.to_s} #{"{#{options.response[request.to_sym]}}" unless options.response[request.to_sym].blank?}"
            end
          end
          action_str << "\tend"
        
        action_str << "end"        
        action_str.join("\n")
      end
      
    end
    
  end
end