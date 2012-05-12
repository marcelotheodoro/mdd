# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mdd/version"

Gem::Specification.new do |s|
  s.name        = "mdd"
  s.version     = Mdd::VERSION
  s.authors     = ["Marcelo Theodoro"]
  s.email       = ["marcelo.theodorojr@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gem para geração de código usando MDD}
  s.description = %q{Tese de mestrado: Uma abordagem orientada a modelos para desenvolvimento de aplicações Web}

  s.rubyforge_project = "mdd"
  
  s.add_dependency 'rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'devise'
  s.add_dependency 'cancan'
  s.add_dependency 'will_paginate'
  s.add_dependency 'nested_form'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end