# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mdwa/version"

Gem::Specification.new do |s|
  s.name        = "mdd"
  s.version     = MDWA::VERSION
  s.authors     = ["Marcelo Theodoro"]
  s.email       = ["marcelo.theodorojr@gmail.com"]
  s.homepage    = "https://github.com/marcelotheodoro/mdd"
  s.summary     = %q{MDD-based code generation tools to avoid repetitive tasks in Rails dev.}
  s.description = %q{Implements a set of tools for code generation for Rails apps. It's based on Theodoro's MDWA approach for web applications.}

  s.rubyforge_project = "mdd"
  
  s.add_dependency 'rails', '>= 3.1'
  s.add_dependency 'jquery-rails', '>= 2.1'
  s.add_dependency 'devise', '>= 2.1'
  s.add_dependency 'cancan', '>= 1.6'
  s.add_dependency 'will_paginate', '>= 3.0'
  s.add_dependency 'nested_form', '>= 0.2.3'
  s.add_dependency 'require_all', '>= 1.2.1'
  s.add_development_dependency 'minitest', '>= 3.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end