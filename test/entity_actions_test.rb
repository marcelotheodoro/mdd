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
      
      e.member_action :publish
    end 
  end
  
  it "should store resource actions correctly" do 
    product = MDWA::DSL.entity('Product')
    product.actions.actions.count.must_equal 7
    product.actions.actions[:index].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:index].collection?.must_equal true
    product.actions.actions[:index].member?.must_equal false
    product.actions.actions[:index].name.must_equal :index
    
    product.actions.actions[:new].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:new].collection?.must_equal true
    product.actions.actions[:new].name.must_equal :new
    
    product.actions.actions[:edit].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:edit].collection?.must_equal false
    product.actions.actions[:edit].member?.must_equal true
    product.actions.actions[:edit].name.must_equal :edit
    
    product.actions.actions[:show].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:show].member?.must_equal true
    product.actions.actions[:show].name.must_equal :show
    
    product.actions.actions[:create].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:create].collection?.must_equal true
    product.actions.actions[:create].name.must_equal :create
    
    product.actions.actions[:update].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:update].member?.must_equal true
    product.actions.actions[:update].name.must_equal :update
    
    product.actions.actions[:delete].must_be_instance_of MDWA::DSL::Action
    product.actions.actions[:delete].member?.must_equal true
    
    product.actions.actions[:no_ecsiste].must_equal nil
    
  end
  
  # it "should not generate actions for non-resourceful entities" do
  #   
  #   MDWA::DSL.entities.register 'Category' do |e|
  #     e.resource = false
  #   end
  #   
  #   category = MDWA::DSL.entity('Category')
  #   category.actions.actions.count.zero?.must_equal true
  #   
  # end
  
  it "should generate correct code" do
    # product = MDWA::DSL.entity('Product')
    # puts product.actions.generate_routes
  end
  
end