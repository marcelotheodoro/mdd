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
  
  s.add_dependency 'rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'devise'
  s.add_dependency 'cancan'
  s.add_dependency 'will_paginate'
  s.add_dependency 'nested_form'
  s.add_development_dependency 'minitest'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end