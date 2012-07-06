# -*- encoding : utf-8 -*-
require 'mdd/layout'

require 'minitest/spec'
require 'minitest/autorun'

describe MDD::Layout::Base do
  
  before do
   
    # sets the layout rules
    MDD::Layout::Base.config do |config|
    	config['/*'] 						            = 'public'
      config['/a/*'] 						          = 'system'
      config['/a/users/passwords#*'] 		  = 'system'
      config['/a/users/sessions#new'] 	  = 'login'
      config['/a/users/sessions#create'] 	= 'login'
    end
    
  end

end