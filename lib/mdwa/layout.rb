# -*- encoding : utf-8 -*-
require 'active_support'
require "action_controller"

module MDWA

  module Layout
  	autoload :Base, 'mdwa/layout/base'
  	autoload :Helper, 'mdwa/layout/helper'
	
  	# include the layout selector in ApplicationController
    ActionController::Base.send :include, MDWA::Layout::Helper
    ActiveSupport.on_load(:action_controller) do
        helper_method "current_page"
    end
  end
  
end