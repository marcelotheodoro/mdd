class <%= @model.klass %> < ActiveRecord::Base
  
  attr_accessible <%= @model_attributes.collect {|m| ":" + m.name }.join(', ') %>

  <%- @model_attributes.select {|m| m.references? }.each do |attr| %>
  belongs_to :<%= attr.type.singular_name %>, :class_name => '<%= attr.type.klass %>'
  <%- end %>
  
end