# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDWA::DSL::Entities do
  
  before do
    # create product entity
    MDWA::DSL.entities.register "Product" do |e|
      e.purpose   = 'Store the company products.'
      e.resource  = true
      e.ajax      = true
      
      ## attributes
      e.attribute do |attr|
        attr.name = 'name'
        attr.type = 'string'
      end
      e.attribute do |attr|
        attr.name = 'category'
        attr.type = 'integer'
      end
      e.attribute do |attr|
        attr.name = 'stock'
        attr.type = 'integer'
      end
      e.attribute do |attr|
        attr.name = 'published'
        attr.type = 'boolean'
      end
      
      ## associations
      e.association do |a|
        a.destination = 'Category'
        a.type = 'many_to_one'
        a.description = 'Holds the category'
      end
      
      e.association do |a|
        a.name = 'marca'
        a.destination = 'Brand'
        a.type = 'one_to_many'
        a.composition = true
        a.description = 'Product`s brand'
      end
      
      e.association do |a|
        a.destination = 'Category2'
        a.type = 'one_to_one'
      end
      
      e.association do |a|
        a.destination = 'Category3'
        a.type = 'one_to_one'
        a.composition = true
      end
      
      e.association do |a|
        a.destination = 'Category4'
        a.type = 'one_to_many'
      end
      
      e.association do |a|
        a.destination = 'Category5'
        a.type = 'one_to_one_not_navigable'
      end
      
      e.association do |a|
        a.destination = 'Category6'
        a.type = 'many_to_many'
      end
      
      e.association do |a|
        a.destination = 'Category7'
        a.type = 'many_to_one'
      end
      
    end
    MDWA::DSL.entity("Product").must_be_instance_of MDWA::DSL::Entity
    
    # create category entity
    MDWA::DSL.entities.register "Category" do |e|
      e.resource = false
      e.attribute do |attr|
        attr.name = 'name'
        attr.type = 'string'
      end
    end
    MDWA::DSL.entity("Category").must_be_instance_of MDWA::DSL::Entity
  end
  
  
  it "must create entities list by default" do
    MDWA::DSL.entities.must_be_instance_of MDWA::DSL::Entities
    MDWA::DSL.entities.nodes.must_be_instance_of Hash
  end
  
    
  it "must keep track of every element initialized" do
    product = MDWA::DSL.entity("Product")
    product.must_be_instance_of MDWA::DSL::Entity
    product.resource.must_equal true
    product.ajax.must_equal true
    product.associations.must_be_instance_of Hash
    product.attributes.must_be_instance_of Hash
    product.model_name.must_equal( "Product" )
    
    category = MDWA::DSL.entity("Category")
    category.must_be_instance_of MDWA::DSL::Entity
    category.resource.must_equal false
    category.associations.must_be_instance_of Hash
    category.attributes.must_be_instance_of Hash
  end
  
  it "must override elements" do
    MDWA::DSL.entities.register "Product" do |e|
      e.resource = false
    end
    MDWA::DSL.entity("Product").resource.must_equal false
  end
  
  it "must store attributes" do 
    product = MDWA::DSL.entity("Product")
    
    product.attributes.count.must_equal 4
    product.attributes['name'].type.must_equal 'string'
    product.attributes['name'].name.must_equal 'name'
    product.attributes['category'].type.must_equal 'integer'
    product.attributes['category'].name.must_equal 'category'
    product.attributes['published'].type.must_equal 'boolean'
    product.attributes['published'].name.must_equal 'published'
    product.attributes['stock'].type.must_equal 'integer'
    product.attributes['stock'].name.must_equal 'stock'
    
    product.default_attribute.name.must_equal 'name'
    
    category = MDWA::DSL.entity("Category")
    category.attributes.count.must_equal 1
    category.default_attribute.name.must_equal 'name'
  end
  
  it "must keep associations" do
      
    product = MDWA::DSL.entity("Product")
    product.associations.count.must_equal 8
    
    product.associations['category'].type.must_equal 'many_to_one'
    product.associations['category'].destination.must_equal 'Category'
    product.associations['category'].generator_type.must_equal 'belongs_to'
    
    product.associations['brand'].must_equal nil
    product.associations['marca'].type.must_equal 'one_to_many'
    product.associations['marca'].destination.must_equal 'Brand'
    product.associations['marca'].generator_type.must_equal 'nested_many'
    
    product.associations['category2'].generator_type.must_equal 'belongs_to'
    product.associations['category3'].generator_type.must_equal 'nested_one'
    product.associations['category4'].generator_type.must_equal 'has_many'
    product.associations['category5'].generator_type.must_equal 'has_one'
    product.associations['category6'].generator_type.must_equal 'has_and_belongs_to_many'
    product.associations['category7'].generator_type.must_equal 'belongs_to'
    
  end
  
  it "must generated correct code" do
    
    MDWA::DSL.entities.register "Project" do |p|
      p.resource = true
      p.scaffold_name = 'a/project'
      p.ajax = true
      
      p.attribute do |a|
        a.name = 'nome'
        a.type = 'string'
      end
      p.attribute do |a|
        a.name = 'ativo'
        a.type = 'boolean'
      end
      p.attribute do |a|
        a.name = 'situacao_atual'
        a.type = 'text'
      end
      
      p.association do |assoc|
        assoc.destination = 'Group'
        assoc.type = 'many_to_one'
      end
    end
    
    MDWA::DSL.entities.register "Group" do |p|
      p.resource = true
      p.scaffold_name = 'a/group'
      p.ajax = true
      p.force = true
      
      p.attribute do |a|
        a.name = 'nome'
        a.type = 'string'
      end
      
      p.attribute do |a|
        a.name = 'ativo'
        a.type = 'boolean'
      end
    end
    
    project = MDWA::DSL.entity("Project")
    group = MDWA::DSL.entity("Group")
    
    project.scaffold_name.must_equal 'a/project'
    project.model_name.must_equal 'a/project'
    
    project.generate.must_equal "mdwa:scaffold a/project nome:string ativo:boolean situacao_atual:text group:a/group:nome:belongs_to --ajax"
    group.generate.must_equal "mdwa:scaffold a/group nome:string ativo:boolean --ajax --force"
  end
  
  it "should not generate non-resource entities" do
    MDWA::DSL.entities.register "Task" do |p|
      p.resource = false
      p.scaffold_name = 'a/task'
      p.ajax = true
      p.force = true
      
      p.attribute do |a|
        a.name = 'name'
        a.type = 'string'
      end
      
      p.attribute do |a|
        a.name = 'active'
        a.type = 'boolean'
      end
    end
    
    task = MDWA::DSL.entity('Task')
    task.generate.must_equal nil
  end
  
end
