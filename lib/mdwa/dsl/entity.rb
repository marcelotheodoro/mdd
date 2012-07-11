# -*- encoding : utf-8 -*-
module MDWA
  module DSL

    class Entity
      
      attr_accessor :name, :resource, :purpose, :scaffold_name, :model_name, :ajax, :generated, :force
      attr_accessor :attributes, :associations
      
      def initialize( name )
        # set the entity name
        self.name = name
        
        # fixed attributes
        self.resource    = false
        self.ajax        = false
        self.generated   = false
        self.force       = false
        
        # arrays
        self.attributes   = {}
        self.associations = {}
      end
      
      def name=(value)
        @name = value
        
        self.scaffold_name  = @name if self.scaffold_name.blank?
        self.model_name     = self.scaffold_name if self.model_name.blank?
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
      # Defines one association
      #
      def association
        assoc = EntityAssociation.new(self)
        yield( assoc ) if block_given?
        # assoc.raise_errors_if_invalid!
        self.associations[assoc.name] = assoc
      end
      
      def generate
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
        
        "mdwa:scaffold #{gen.join(' ')}"
      end
      
    end

  end
end