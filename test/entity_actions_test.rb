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

      e.member_action :publish, :get, :html
      e.collection_action :export, :post, [:csv, :xml]
      e.collection_action :report, :get, [:ajax]
    end 
  end
  
  it "should create action correctly" do 
    product_entity = MDWA::DSL.entity('Product')
    action = MDWA::DSL::Action.new( product_entity, :publish, :member, :method => :get, :request_type => [:html, :ajax_js] )
    action.name.must_equal :publish
    action.member?.must_equal true
    action.method.must_equal :get
    action.resource?.must_equal false
    action.request_type.must_equal [:html, :ajax_js]
  end
  
  it "should store resource actions correctly" do 
    product = MDWA::DSL.entity('Product')
    product.actions.actions.count.must_equal 10
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
  
  it "should work well with non-resourceful actions" do 
    product = MDWA::DSL.entity('Product')
    product.actions.member_actions.count.must_equal 1
    product.actions.actions[:publish].name.must_equal :publish
    product.actions.actions[:publish].method.must_equal :get
    product.actions.actions[:publish].request_type.must_equal [:html]
    product.actions.actions[:publish].resource?.must_equal false
    
    product.actions.collection_actions.count.must_equal 2
    product.actions.actions[:export].name.must_equal :export
    product.actions.actions[:export].method.must_equal :post
    product.actions.actions[:export].request_type.must_equal [:csv, :xml]
    product.actions.actions[:export].resource?.must_equal false
    
    product.actions.actions[:report].name.must_equal :report
    product.actions.actions[:report].method.must_equal :get
    product.actions.actions[:report].request_type.must_equal [:ajax]
    product.actions.actions[:report].resource?.must_equal false
  end
  
  it "should not generate actions for non-resourceful entities" do
    
    MDWA::DSL.entities.register 'Reports' do |e|
      e.resource = false
    end
    
    reports = MDWA::DSL.entity('Reports')
    reports.actions.actions.count.must_equal 0
    
  end

  
end
