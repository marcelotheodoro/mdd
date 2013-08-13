# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/autorun'

describe MDWA::DSL::EntityAttribute do
  
  before do
    # create product entity
    MDWA::DSL.entities.register "Pessoa" do |e|
      e.resource  = true
      e.ajax      = true

      e.attribute 'nome', 'string', default: true, filtered: true
      e.attribute 'documento', 'string', filtered: true
      e.attribute 'endereco', 'string'
      e.attribute 'campo', 'string', filtered: false
    end 
  end
  
  it "should store attributes correctly" do 
    entidade = MDWA::DSL.entity('Pessoa')

    entidade.attributes.count.must_equal 8
    entidade.attributes['nome'].options.count.must_equal 2
    entidade.attributes['nome'].default.must_equal true
    entidade.attributes['nome'].options[:filtered].must_equal true
    entidade.attributes['nome'].options[:outro].must_equal nil

    entidade.attributes['documento'].options.count.must_equal 1
    entidade.attributes['documento'].default.must_equal false
    entidade.attributes['documento'].options[:filtered].must_equal true
    entidade.attributes['documento'].options[:outro].must_equal nil

    entidade.attributes['endereco'].options.count.must_equal 0
    entidade.attributes['endereco'].default.must_equal false
    entidade.attributes['endereco'].options[:filtered].must_equal nil

    entidade.attributes.values.select{|attr| attr.options[:filtered]}.count.must_equal 2
  end

end