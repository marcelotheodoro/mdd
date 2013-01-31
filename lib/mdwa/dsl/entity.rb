# -*- encoding : utf-8 -*-
require 'mdwa/generators'

module MDWA
  module DSL

    class Entity
      
      attr_accessor :name, :resource, :user, :purpose, :scaffold_name, :model_name, :ajax, :force
      attr_accessor :attributes, :associations, :actions, :specifications, :code_generations, :in_requirements
      
      def initialize( name )
        # set the entity name
        self.name = name
        
        # arrays
        self.attributes       = {}
        self.associations     = {}
        self.actions          = EntityActions.new(self)
        self.specifications   = []
        self.code_generations = []
        self.in_requirements  = []
        
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
        return (@scaffold_name.blank? ? name.underscore : @scaffold_name)
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
      
      def ajax?
        self.ajax
      end
      
      def force?
        self.force
      end
      
      def user?
        self.user
      end
      
      #
      # Executed after the entity is declared, but before the inclusion in the entities singleton array.
      #
      def after_declaration
        
        # include rails default attributes
        self.attribute('id', 'integer') if self.attributes['id'].blank?
        self.attribute('created_at', 'datetime') if self.attributes['created_at'].blank?
        self.attribute('updated_at', 'datetime') if self.attributes['updated_at'].blank?
        # if it's a user and have no attributes, include "name" to prevent errors
        if user?
          self.attribute('name', 'string')
          self.attribute('email', 'string')
          self.attribute('password', 'password')
          self.attribute('password_confirmation', 'password')
        end
        
      end
      
      #
      # Declares one attribute of the list using the block given.
      def attribute(name, type, options = {})     
        attr = EntityAttribute.new(self)
        attr.name = name
        attr.type = type
        attr.default = true if options.include?(:default)
        attr.options = options
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
      # Entity specifications.
      # Params: description and block
      #
      def specify(description)
        specification = EntitySpecification.new(description)
        yield(specification) if block_given?
        self.specifications << specification
      end
      
      #
      # Return an instance of Generators::Model
      #
      def generator_model
        @generator_model = Generators::Model.new(self.scaffold_name)
        @generator_model.specific_model_name = self.model_name if(!self.model_name.blank? and self.model_name != self.scaffold_name)
        self.attributes.values.each do |attribute|
          @generator_model.add_attribute Generators::ModelAttribute.new( "#{attribute.name}:#{attribute.type}" )
        end
        self.associations.values.each do |association|
          model1 = Generators::Model.new(self.model_name)
          entity2 = DSL.entity(association.destination)
          model2 = Generators::Model.new(entity2.model_name)
          assoc = Generators::ModelAssociation.new(model1, model2, association.generator_type, entity2.default_attribute.name)
          assoc.composition = true if association.composition
          assoc.skip_views  = association.skip_views
          @generator_model.associations << assoc
        end
        return @generator_model
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
        default_attr = self.attributes.values.first # first element value
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
        
        "mdwa:#{user? ? 'user_scaffold': 'scaffold'} #{gen.join(' ')}"
      end
      
    end

  end
end
