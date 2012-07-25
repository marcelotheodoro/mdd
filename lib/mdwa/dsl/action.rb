# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class Action
      
      ACTION_TYPES    = [:collection, :member]
      ALLOWED_METHODS = [:get, :post, :put, :delete]
      PREDEFINED_REQUEST_TYPES   = [:html, :ajax, :ajax_js, :modalbox]
      
      attr_accessor :name, :type, :entity, :method, :request_type, :response, :resource
      
      def initialize(entity, name, type, options = {})
        self.name         = name.to_sym
        self.type         = type.to_sym
        self.entity       = entity
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
          @response = value
        else
          @response = {self.method.first.to_sym => value}
        end
      end
      
      def member?
        self.type.to_sym == :member
      end
      
      def collection?
        self.type.to_sym == :collection
      end
      
      def resource?
        resource
      end
      
      def generate_route
        "#{self.method.to_s} '#{self.entity.name.underscore.pluralize}/#{self.name.to_s}' => #{self.name.to_sym}"
      end
      
      def generate_controller
        action_str = []
        action_str << "\tdef #{self.name.to_s}"
        action_str << ""
          action_str << "\t\trespond_to do |format|"        
          self.request_type.each do |request|          
            case request.to_sym
            when :modalbox
              action_str << "\t\t\tformat.html{render :layout => false}"
            when :html
              action_str << "\t\t\tformat.html #{"{#{self.response[:html]}}" unless self.response[:html].blank?}"
            when :ajax
              action_str << "\t\t\tformat.js #{"{#{self.response[:ajax]}}" unless self.response[:ajax].blank?}"
            when :ajax_js
              action_str << "\t\t\tformat.json #{"{#{self.response[:ajax_js]}}" unless self.response[:ajax_js].blank?}"
            else
              action_str << "\t\t\tformat.#{request.to_s} #{"{#{self.response[request.to_sym]}}" unless self.response[request.to_sym].blank?}"
            end
          end
          action_str << "\t\tend"
        
        action_str << "\tend"        
        # action_str.join("\n")
      end
      
    end
    
  end
end
