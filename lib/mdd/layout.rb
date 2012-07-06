# -*- encoding : utf-8 -*-
require 'active_support'
require "action_controller"

module MDD

  module Layout
  	autoload :Base, 'mdd/layout/base'
  	autoload :Helper, 'mdd/layout/helper'
	
  	# include the layout selector in ApplicationController
    ActionController::Base.send :include, MDD::Layout::Helper
    ActiveSupport.on_load(:action_controller) do
        helper_method "current_page"
    end
  end
  
end