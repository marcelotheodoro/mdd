# -*- encoding : utf-8 -*-
require 'mdwa/dsl/entities'
module MDWA
  module DSL
    
    autoload :Entity, 'mdwa/dsl/entity'
    autoload :EntityAttribute, 'mdwa/dsl/entity_attribute'
    autoload :EntityAssociation, 'mdwa/dsl/entity_association'
    autoload :EntityActions, 'mdwa/dsl/entity_actions'
    autoload :Action, 'mdwa/dsl/action'
    
    STRUCTURAL_PATH = 'app/mdwa/structure/'
    NAVIGATION_PATH = 'app/mdwa/navigation/'
    
  end
end