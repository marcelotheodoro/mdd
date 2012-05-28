require "mdd/version"

module Mdd
  class Mdd < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end

  module Generators
  	autoload :ModelAttribute, 'mdd/layout/model_attribute'
  end

  module Layout
  	autoload :Base, 'mdd/layout/base'
  	autoload :Helper, 'mdd/layout/helper'
  end
end

# include the layout selector in ApplicationController
ActionController::Base.send :include, Mdd::Layout::Helper