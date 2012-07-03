Mdd::Layout::Base.config do |config|
	config['/*'] 						            = 'public'
  config['/a/*'] 						          = 'system'
  config['/a/users/passwords#*'] 		  = 'system'
  config['/a/users/sessions#new'] 	  = 'login'
  config['/a/users/sessions#create'] 	= 'login'
end