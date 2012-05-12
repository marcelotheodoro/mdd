Mdd::Layout::Base.config do |config|
	config['/*'] 						= 'mdwa/public'
    config['/a/*'] 						= 'mdwa/system'
    config['/a/users/passwords#*'] 		= 'mdwa/system'
    config['/a/users/sessions#new'] 	= 'mdwa/login'
    config['/a/users/sessions#create'] 	= 'mdwa/login'
end