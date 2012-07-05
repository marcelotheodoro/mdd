# -*- encoding : utf-8 -*-
require "mdd/version"

module MDD
  class MDD < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end
  
  module Generators
  	autoload :Model, 'mdd/generators/model'
    autoload :ModelAttribute, 'mdd/generators/model_attribute'
  end

  module Layout
  	autoload :Base, 'mdd/layout/base'
  	autoload :Helper, 'mdd/layout/helper'
  end
end

# include the layout selector in ApplicationController
ActionController::Base.send :include, MDD::Layout::Helper
ActiveSupport.on_load(:action_controller) do
    helper_method "current_page"
end