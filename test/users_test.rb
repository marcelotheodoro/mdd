# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDWA::Layout::Base do
  
  before do
    
    MDWA::DSL.users.register 'Administrator' do |u|
      u.description = 'Administrator and super user of the system.'
      
      u.user_roles = ['Administrator', 'SuperAdmin', 'Director']
    end
    
    MDWA::DSL.users.register 'Programmer' do |u|
      u.user_roles = 'Tester'
    end
    
    MDWA::DSL.users.register 'Tester' do |u| 
    end
    
  end
  
  it "should store correct values" do 
    
    administrator = MDWA::DSL.user 'Administrator'
    programmer    = MDWA::DSL.user 'Programmer'
    tester        = MDWA::DSL.user 'Tester'
    
    MDWA::DSL.users.all.count.must_equal 3
    
    administrator.name.must_equal 'Administrator'
    administrator.description.must_equal 'Administrator and super user of the system.'
    administrator.user_roles.count.must_equal 3
    administrator.user_roles.include?( 'SuperAdmin' ).must_equal true
    administrator.user_roles.include?( 'Director' ).must_equal true
    administrator.user_roles.include?( 'Administrator' ).must_equal true
    administrator.user_roles.include?( 'Manager' ).must_equal false
    
    programmer.name.must_equal 'Programmer'
    programmer.description.blank?.must_equal true
    programmer.user_roles.count.must_equal 2
    programmer.user_roles.include?('Programmer').must_equal true
    programmer.user_roles.include?('Tester').must_equal true
    programmer.user_roles.include?('Director').must_equal false
    
    tester.name.must_equal 'Tester'
    tester.user_roles.count.must_equal 1
    tester.user_roles.include?('Tester').must_equal true
    
  end
  
end
