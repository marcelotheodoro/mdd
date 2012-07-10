class <%= @model.klass %> < ActiveRecord::Base
  
	attr_accessible <%= @model.simple_attributes.collect {|a| ":" + a.name }.join(', ') %>
  
end