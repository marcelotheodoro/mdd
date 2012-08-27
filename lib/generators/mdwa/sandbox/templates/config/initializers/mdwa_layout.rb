# -*- encoding : utf-8 -*-
require 'mdwa/layout'
MDWA::Layout::Base.config do |config|
	config['/*'] 						            = 'public'
  config['/a/*'] 						          = 'system'
  config['/a/users/passwords#*'] 		  = 'system'
  config['/a/users/sessions#new'] 	  = 'login'
  config['/a/users/sessions#create'] 	= 'login'
  
  # Software visualization in development environment
  config['/mdwa/*']                   = 'mdwa_visualization'
end
