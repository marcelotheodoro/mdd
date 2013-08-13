# -*- encoding : utf-8 -*-
require 'mdwa/layout'

require 'minitest/autorun'

describe MDWA::Layout::Base do
  
  before do
   
    # sets the layout rules
    MDWA::Layout::Base.config do |config|
    	config['/*'] 						            = 'public'
      config['/a/*'] 						          = 'system'
      config['/a/users/passwords#*'] 		  = 'system'
      config['/a/users/sessions#*']       = 'other_layout'
      config['/a/users/sessions#new'] 	  = 'login'
      config['/a/users/sessions#create'] 	= 'login'
    end
    
  end
  
  it "must return correct paths" do
    MDWA::Layout::Base.select_layout("/products").must_equal 'public'
    MDWA::Layout::Base.select_layout("/produtos#show").must_equal 'public'
    MDWA::Layout::Base.select_layout("/produtos#index").must_equal 'public'
    MDWA::Layout::Base.select_layout("/produtos#new").must_equal 'public'
    MDWA::Layout::Base.select_layout("/produtos#create").must_equal 'public'
    MDWA::Layout::Base.select_layout("/produtos#update").must_equal 'public'
    MDWA::Layout::Base.select_layout("/produtos#destroy").must_equal 'public'
    MDWA::Layout::Base.select_layout("/categories#show").must_equal 'public'
    MDWA::Layout::Base.select_layout("/categories#index").must_equal 'public'
    MDWA::Layout::Base.select_layout("/categories#new").must_equal 'public'
    MDWA::Layout::Base.select_layout("/categories#create").must_equal 'public'
    MDWA::Layout::Base.select_layout("/categories#update").must_equal 'public'
    MDWA::Layout::Base.select_layout("/categories#destroy").must_equal 'public'
    
    MDWA::Layout::Base.select_layout("/a/produtos#show").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/categories#show").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/users#show").must_equal 'system'

    MDWA::Layout::Base.select_layout("/a/users#show").must_equal 'system'    
    MDWA::Layout::Base.select_layout("/a/users#show").must_equal 'system'    
    MDWA::Layout::Base.select_layout("/a/users#show").must_equal 'system'    
    
    MDWA::Layout::Base.select_layout("/a/users/passwords#show").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/users/passwords#index").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/users/passwords#new").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/users/passwords#create").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/users/passwords#update").must_equal 'system'
    MDWA::Layout::Base.select_layout("/a/users/passwords#destroy").must_equal 'system'
    
    MDWA::Layout::Base.select_layout("/a/users/sessions#new").must_equal 'login'
    MDWA::Layout::Base.select_layout("/a/users/sessions#create").must_equal 'login'

    MDWA::Layout::Base.select_layout("/a/users/sessions#other_method").must_equal 'other_layout'
  end

end
