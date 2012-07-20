# -*- encoding : utf-8 -*-
require 'mdwa/generators'

module MDWA
  module DSL

    class Entity
      
      attr_accessor :name, :resource, :user, :purpose, :scaffold_name, :model_name, :ajax, :force
      attr_accessor :attributes, :associations, :actions, :code_generations
      
      def initialize( name )
        # set the entity name
        self.name = name
        
        # arrays
        self.attributes   = {}
        self.associations = {}
        self.code_generations = []
        self.actions      = EntityActions.new(self)
        
        # fixed attributes
        self.resource    = true
        self.user        = false
        self.ajax        = false
        self.force       = false
      end
      
      def name=(value)
        @name = value
      end
      
      def scaffold_name
        return (@scaffold_name.blank? ? name : @scaffold_name)
      end
      
      def model_name
        return (@model_name.blank? ? scaffold_name : @model_name)
      end
      
      def resource=(value)
        @resource = value
        
        # if entity is resorceful, generate default resource action
        if resource?
          self.actions.set_resource_actions 
        else
          self.actions.clear_resource_actions
        end
      end
      
      def resource?
        self.resource
      end
      
      def force?
        self.force
      end
      
      def user?
        self.user
      end
      
      #
      # Declares one attribute of the list using the block given.
      #
      def attribute
        attr = EntityAttribute.new(self)
        yield( attr ) if block_given?
        attr.raise_errors_if_invalid!
        self.attributes[attr.name] = attr
      end
      
      #
      # Defines one association
      #
      def association
        assoc = EntityAssociation.new(self)
        yield( assoc ) if block_given?
        # assoc.raise_errors_if_invalid!
        self.associations[assoc.name] = assoc
      end
      
      #
      # Include a member action
      # Params: name, method = get, request_type = html
      def member_action(name, method = nil, request_type = nil)
        self.actions.member_action(name, method, request_type)
      end
      
      #
      # Include a collection action
      # Params: name, method = get, request_type = html
      def collection_action(name, method, request_type)
        self.actions.collection_action(name, method, request_type)
      end
      
      #
      # Returns the associated model in app/models folder
      #
      def model_class
        Generators::Model.new(self.model_name).model_class
      end
      
      #
      # Entity file name  
      #
      def file_name
        self.name.singularize.underscore
      end
      
      #
      # Selects the default attribute of the entity
      #
      def default_attribute
        default_attr = self.attributes.first.last # first element value
        self.attributes.each do |key, attr|
          default_attr = attr if attr.default?
        end
        return default_attr
      end
      
      #
      # Generate MDWA scaffold code for structural schema.
      #
      def generate
        # generates nothing if is not a resource
        return nil unless self.resource
        
        gen = []
        gen << scaffold_name
        
        attributes.each do |key, attr|
          gen << attr.generate
        end
        
        associations.each do |key, assoc|
          gen << assoc.generate
        end
        
        gen << "--ajax" if ajax
        gen << "--force" if force
        gen << "--model='#{model_name}'" if model_name != scaffold_name
        
        "mdwa:#{user? ? 'user': 'scaffold'} #{gen.join(' ')}"
      end
      
    end

  end
end