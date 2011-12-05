require "mdd/version"
require "inflections"

module Mdd
  class Mdd < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end
end
