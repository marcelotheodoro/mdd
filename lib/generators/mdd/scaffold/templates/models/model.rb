class <%= namespace_model_class %> < ActiveRecord::Base
  
  attr_accessible <%= @model_attributes.reject {|m| m.references? }.collect {|m| ":" + m.name }.join(', ') %>

  <%- @model_attributes.select {|m| m.references? }.each do |attr| %>
  belongs_to :<%= attr.type %>
  <%- end %>
  
end