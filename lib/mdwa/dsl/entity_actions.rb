# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class EntityActions
      
      attr_accessor :entity, :actions
      
      def initialize(entity)
        self.entity   = entity
        self.actions  = {}
      end
      
      def member_action(name, method, request_type)
        self.actions[name.to_sym] = Action.new(self.entity, name.to_sym, :member, :method => method, :request_type => request_type)
      end
      
      #
      # Include a collection action
      # Params: name, method = get, request_type = html
      def collection_action(name, method, request_type)
        self.actions[name.to_sym] = Action.new(self.entity, name.to_sym, :collection, :method => method, :request_type => request_type)
      end
      
      def member_actions
        actions.values.to_a.select{|a| a.member? and !a.resource?}
      end
      
      def collection_actions
        actions.values.to_a.select{|a| a.collection? and !a.resource?}
      end
      
      def generate_routes
        routes = {}
        self.actions.values.select {|a| !a.resource?}.each do |action|
          routes[action.name] = action.generate_route
        end
        return routes
      end
      
      def generate_controller
        controller = {}
        self.actions.values.select {|a| !a.resource?}.each do |action|
          controller[action.name] = action.generate_controller
        end
        return controller
      end
      
      # Returns all resource actions
      def set_resource_actions
        self.actions[:index]   = Action.new(self.entity, :index, :collection, :resource => true)
        self.actions[:new]     = Action.new(self.entity, :new, :collection, :resource => true)
        self.actions[:edit]    = Action.new(self.entity, :edit, :member, :resource => true)
        self.actions[:show]    = Action.new(self.entity, :show, :member, :resource => true)
        self.actions[:create]  = Action.new(self.entity, :create, :collection, :method => :post, :resource => true)
        self.actions[:update]  = Action.new(self.entity, :update, :member, :method => :put, :resource => true)
        self.actions[:delete]  = Action.new(self.entity, :delete, :member, :method => :delete, :resource => true)
      end
      
      def clear_resource_actions
        self.actions.delete :index
        self.actions.delete :new
        self.actions.delete :edit
        self.actions.delete :show
        self.actions.delete :create
        self.actions.delete :update
        self.actions.delete :delete
      end
      
    end
    
  end
end
