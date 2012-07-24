# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDWA::DSL::Entity do
  
  before do 
    MDWA::DSL.entities.register 'Spec' do |e|
      e.resource = true
      
      e.specify "fields should not be invalid" do |s|
        s.such_as "date should be valid"
        s.such_as "administrator must not be empty"
        s.such_as "description must not be empty"
      end
      e.specify "date should not be in the past"
    end
  end
  
  it 'should store specifications correctly' do
    
    entity = MDWA::DSL.entity('Spec')
    entity.specifications.count.must_equal 2
    entity.specifications.first.details.count.must_equal 3
    entity.specifications.last.details.count.must_equal 0
    
    entity.specifications.first.description.must_equal "fields should not be invalid"
    entity.specifications.first.details[0].must_equal "date should be valid"
    entity.specifications.first.details[1].must_equal "administrator must not be empty"
    entity.specifications.first.details[2].must_equal "description must not be empty"
    entity.specifications.last.description.must_equal "date should not be in the past"
    
  end
  
end
