# -*- encoding : utf-8 -*-
require 'mdd/dsl/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDD::DSL::Entities do
  
  it "must create entities list by default" do
    MDD::DSL.entities.must_be_instance_of MDD::DSL::Entities
    MDD::DSL.entities.nodes.must_be_instance_of Hash
  end
  
  
  it "must access the right elements" do
    # create product entity
    MDD::DSL.entities.register "Product" do |e|
      e.resource = true
    end
    MDD::DSL.entity("Product").must_be_instance_of MDD::DSL::EntityNode
    
    # create category entity
    MDD::DSL.entities.register "Category" do |e|
      e.resource = false
    end
    MDD::DSL.entity("Category").must_be_instance_of MDD::DSL::EntityNode
  end
  
  
  it "must keep track of every element initialized" do
    product = MDD::DSL.entity("Product")
    product.must_be_instance_of MDD::DSL::EntityNode
    product.resource.must_equal true
    
    category = MDD::DSL.entity("Category")
    category.must_be_instance_of MDD::DSL::EntityNode
    category.resource.must_equal false
  end
  
  it "must not store other stuff" do
    MDD::DSL.entities.nodes.size.must_equal 2
  end
  
  it "must override elements" do
  end
  
end