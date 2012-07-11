# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDWA::DSL::Entities do
  
  before do
    # create product entity
    MDWA::DSL.entities.register "Product" do |e|
      e.purpose   = 'Store the company products.'
      e.resource  = true
      e.ajax      = true
      e.generated = false
      
      ## attributes
      e.attribute do |attr|
        attr.name = 'name'
        attr.type = 'string'
      end
      e.attribute do |attr|
        attr.name = 'category'
        attr.type = 'integer'
      end
      e.attribute do |attr|
        attr.name = 'stock'
        attr.type = 'integer'
      end
      e.attribute do |attr|
        attr.name = 'published'
        attr.type = 'boolean'
      end
      
    end
    MDWA::DSL.entity("Product").must_be_instance_of MDWA::DSL::Entity
    
    # create category entity
    MDWA::DSL.entities.register "Category" do |e|
      e.resource = false
      e.attribute do |attr|
        attr.name = 'name'
        attr.type = 'string'
      end
    end
    MDWA::DSL.entity("Category").must_be_instance_of MDWA::DSL::Entity
  end
  
  
  it "must create entities list by default" do
    MDWA::DSL.entities.must_be_instance_of MDWA::DSL::Entities
    MDWA::DSL.entities.nodes.must_be_instance_of Hash
  end
  
    
  it "must keep track of every element initialized" do
    product = MDWA::DSL.entity("Product")
    product.must_be_instance_of MDWA::DSL::Entity
    product.resource.must_equal true
    product.ajax.must_equal true
    product.generated.must_equal false
    product.associations.must_be_instance_of Hash
    product.attributes.must_be_instance_of Hash
    product.model_name.must_equal( "Product" )
    
    category = MDWA::DSL.entity("Category")
    category.must_be_instance_of MDWA::DSL::Entity
    category.resource.must_equal false
    category.associations.must_be_instance_of Hash
    category.attributes.must_be_instance_of Hash
  end
  
  
  it "must not store other stuff" do
    MDWA::DSL.entities.nodes.size.must_equal 2
  end
  
  
  it "must override elements" do
    MDWA::DSL.entities.register "Product" do |e|
      e.resource = false
    end
    MDWA::DSL.entity("Product").resource.must_equal false
  end
  
  it "must store attributes" do 
    product = MDWA::DSL.entity("Product")
    
    product.attributes.count.must_equal 4
    product.attributes['name'].type.must_equal 'string'
    product.attributes['name'].name.must_equal 'name'
    product.attributes['category'].type.must_equal 'integer'
    product.attributes['category'].name.must_equal 'category'
    product.attributes['published'].type.must_equal 'boolean'
    product.attributes['published'].name.must_equal 'published'
    product.attributes['stock'].type.must_equal 'integer'
    product.attributes['stock'].name.must_equal 'stock'
    
    product.default_attribute.name.must_equal 'name'
    
    category = MDWA::DSL.entity("Category")
    category.attributes.count.must_equal 1
    category.default_attribute.name.must_equal 'name'
  end
  
end