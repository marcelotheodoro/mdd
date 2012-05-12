require "mdd/version"

module Mdd
  class Mdd < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end

  module Layout
  	autoload :Base, 'mdd/layout/base'
  end
end
