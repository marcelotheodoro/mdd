# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class EntityActions
      
      attr_accessor :entity, :actions
      
      def initialize(entity)
        self.entity   = entity
        self.actions  = {}
      end
      
      def member_action(member, method, request_type)
        self.actions[:name] = Action.new(name, :member, method, request_type)
      end
      
      #
      # Include a collection action
      # Params: name, method = get, request_type = html
      def collection_action(member, method, request_type)
        self.actions[:name] = Action.new(name, :collection, method, request_type)
      end
      
      def generate_routes
        routes = []
        self.actions.values do |action|
          routes << "#{action.method.to_s} '#{entity.name.underscore.pluralize}/#{action.name.to_s}' => #{action.name.to_sym}"
        end
        return routes
      end
      
      def generate_controller
        controller = []
        self.actions.value.select {|a| !a.resource?}.each do |action|
          controller << action.generate_controller
        end
        # controller.join("\n\n")
      end
      
      # Returns all resource actions
      def set_resource_actions
        self.actions[:index]   = Action.new(:index, :collection, :resource => true)
        self.actions[:new]     = Action.new(:new, :collection, :resource => true)
        self.actions[:edit]    = Action.new(:edit, :member, :resource => true)
        self.actions[:show]    = Action.new(:show, :member, :resource => true)
        self.actions[:create]  = Action.new(:create, :collection, :method => :post, :resource => true)
        self.actions[:update]  = Action.new(:update, :member, :method => :put, :resource => true)
        self.actions[:delete]  = Action.new(:delete, :member, :method => :delete, :resource => true)
      end
      
    end
    
  end
end
