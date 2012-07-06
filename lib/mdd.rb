# -*- encoding : utf-8 -*-
require "mdd/version"
require 'rails/engine'

module MDD
  class MDD < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end
end