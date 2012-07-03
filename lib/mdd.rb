require "mdd/version"

module Mdd
  class Mdd < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end
  
  module Dsl
    autoload :Entity, 'mdd/dsl/entity'
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
ActionController::Base.send :include, Mdd::Layout::Helper
ActiveSupport.on_load(:action_controller) do
    helper_method "current_page"
end