# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDWA::DSL::EntityActions do
  
  before do
    # create product entity
    MDWA::DSL.entities.register "Product" do |e|
      e.resource  = true
      e.ajax      = true
    end 
  end
  
  it "should store actions correctly" do 
    product = MDWA::DSL.entity('Product')
    product.actions.actions.count.must_equal 7
  end
  
  it "should generate correct code" do
  end
  
end