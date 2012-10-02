# -*- encoding : utf-8 -*-
require 'rails/engine'
require 'extensions/string'

module MDD
  class MDD < Rails::Engine
    config.autoload_paths << File.expand_path("../app", __FILE__)
  end
end
