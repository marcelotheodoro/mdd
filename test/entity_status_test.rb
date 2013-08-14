# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/autorun'

describe MDWA::DSL::Entities do
  
  before do
    # create sale entity
    MDWA::DSL.entities.register "Sale" do |e|

      e.resource  = true
      e.ajax      = true
      e.scaffold_name = 'a/sale'
      e.model_name = 'a/sale'
      
      e.attribute 'id', 'integer', {filtered: true}
      e.attribute 'data', 'date', {filtered: true}
      e.attribute 'valor', 'float', {filtered: true}
      e.attribute 'status', 'status', {
        filtered: true, 
        possible_values: [:created, :processed, :shipped, :delivered]
      }

    end

  end

  it "should store the right values" do
    sale = MDWA::DSL.entity('Sale')
    sale.attributes.count.must_equal 7
    sale.attributes['status'].must_be_instance_of MDWA::DSL::EntityAttribute
    sale.attributes['status'].type.must_equal 'status'
    sale.attributes['status'].options[:filtered].must_equal true
    sale.attributes['status'].options[:possible_values].must_be_instance_of Array
    sale.attributes['status'].options[:possible_values].count.must_equal 4
    sale.attributes['status'].options[:possible_values].must_equal [:created, :processed, :shipped, :delivered]
  end

end