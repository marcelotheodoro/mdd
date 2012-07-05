# -*- encoding : utf-8 -*-
require 'mdd/dsl/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDD::DSL::Entities do
  
  before do
    # create product entity
    MDD::DSL.entities.register "Product" do |e|
      e.resource  = true
      e.ajax      = true
      e.generated = false
      e.attribute do |attr|
        attr.name = 'test'
      end
    end
    MDD::DSL.entity("Product").must_be_instance_of MDD::DSL::Entity
    
    # create category entity
    MDD::DSL.entities.register "Category" do |e|
      e.resource = false
    end
    MDD::DSL.entity("Category").must_be_instance_of MDD::DSL::Entity
  end
  
  
  it "must create entities list by default" do
    MDD::DSL.entities.must_be_instance_of MDD::DSL::Entities
    MDD::DSL.entities.nodes.must_be_instance_of Hash
  end
  
    
  it "must keep track of every element initialized" do
    product = MDD::DSL.entity("Product")
    product.must_be_instance_of MDD::DSL::Entity
    product.resource.must_equal true
    product.ajax.must_equal true
    product.generated.must_equal false
    product.associations.must_be_instance_of Array
    product.attributes.must_be_instance_of Array
    product.model_name.must_equal( "Product" )
    
    category = MDD::DSL.entity("Category")
    category.must_be_instance_of MDD::DSL::Entity
    category.resource.must_equal false
    category.associations.must_be_instance_of Array
    category.attributes.must_be_instance_of Array
  end
  
  
  it "must not store other stuff" do
    MDD::DSL.entities.nodes.size.must_equal 2
  end
  
  
  it "must override elements" do
    
    MDD::DSL.entities.register "Product" do |e|
      e.resource = false
    end
    MDD::DSL.entity("Product").resource.must_equal false
    
  end
  
end