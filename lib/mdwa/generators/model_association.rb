# -*- encoding : utf-8 -*-
require 'active_support/core_ext'

module MDWA
  module Generators
    
    class ModelAssociation
      
      attr_accessor :model1, :model2, :relation, :reference_field, :composition, :skip_views
      
      ACCEPTED_RELATIONS = [:has_many, :belongs_to, :has_and_belongs_to_many, :nested_many, :nested_one, :has_one]
      
      def initialize(model1_name, model2_name, relation_name, reference_field = nil)
        
        self.model1   = model1_name
        self.model2   = model2_name
        self.relation = relation_name
        self.reference_field = reference_field || 'id'
        self.composition = false
        self.skip_views = false

        # validation
        raise "Invalid model name: #{@model1.name}" unless self.model1.valid?
        raise "Invalid model name: #{@model2.name}" unless self.model2.valid?
        raise "Invalid relation type: #{@relation}" unless self.relation_valid?
      end
      
      def model1=(value)
        if value.is_a? String
          @model1 = Generators::Model.new( value )
        elsif value.is_a? Generators::Model
          @model1 = value
        end
      end
      
      def model2=(value)
        if value.is_a? String
          @model2 = Generators::Model.new( value )
        elsif value.is_a? Generators::Model
          @model2 = value
        end
      end
      
      def composition?
        self.composition
      end
      
      def skip_views?
        self.skip_views
      end
      
      def relation_valid?
        ACCEPTED_RELATIONS.include? relation.to_sym
      end
      
      def ordered
        [@model1, @model2].sort! {|a,b| a.plural_name <=> b.plural_name}
      end
      
      def belongs_to?
				return (relation == 'belongs_to')
			end

			def has_many?
				return (relation == 'has_many')
			end

			def nested_many?
				return (relation == 'nested_many')
			end

			def nested?
				nested_many? || nested_one?
			end

			def nested_one?
				return (relation == 'nested_one')
			end

			def has_one?
				return (relation == 'has_one')
			end

			def has_and_belongs_to_many?
				return (relation == 'has_and_belongs_to_many')
			end


      def filter_input(destination_field)
        input = []
        input << "render '/template/mdwa/autocomplete_tag', :dom_element => '##{self.model2.name.underscore}', :dom_element_id => '##{self.model2.name.underscore}_id', :data => #{model2.klass}.all, :field_name => '#{destination_field}'"
        input << "text_field_tag :#{self.model2.name.underscore}"
        input << "hidden_field_tag :#{self.model2.name.underscore}_id"
        return input
      end
      
    end
    
  end
end
