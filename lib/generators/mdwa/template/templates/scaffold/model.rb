# -*- encoding : utf-8 -*-
===entity_code===
class <%= @model.klass %> < <%= !@entity.user? ? 'ActiveRecord::Base' : 'User' %>

<%- # model attributes -%>
<%- unless @model.attributes.count.zero? -%>
    attr_accessible <%= @model.attributes.collect {|a| ":" + a.name }.join(', ') %>
<%- end -%>
  
<%- # model associations -%>
<%- @model.associations.each do |association| -%>
  <%- if association.belongs_to? -%>
    belongs_to :<%= association.model2.singular_name %>, :class_name => '<%= association.model2.klass %>'
    attr_accessible :<%= association.model2.singular_name.foreign_key %>
  <%- end -%>
  <%- if association.has_one? -%>
    has_one :<%= association.model2.singular_name %>, :class_name => '<%= association.model2.klass %>'
  <%- end -%>
  <%- if association.has_many? -%>
    has_many :<%= association.model2.plural_name %>, :class_name => '<%= association.model2.klass %>'"
  <%- end -%>
  <%- if association.has_and_belongs_to_many? -%>
    has_and_belongs_to_many :<%= association.model2.plural_name %>, :join_table => :<%= many_to_many_table_name %>
  <%- end -%>
  <%- if association.nested_one? -%>
    belongs_to :<%= association.model2.singular_name %>, :class_name => '<%= association.model2.klass %>'
    attr_accessible :<%= association.model2.singular_name %>_attributes, :<%= association.model2.singular_name.foreign_key %>
    accepts_nested_attributes_for :<%= association.model2.singular_name %>, :allow_destroy => true
  <%- end -%>
  <%- if association.nested_many? -%>
    has_many :<%= association.model2.plural_name %>, :class_name => '<%= association.model2.klass %>', :dependent => :destroy
    attr_accessible :<%= association.model2.plural_name %>_attributes
    accepts_nested_attributes_for :<%= association.model2.plural_name %>, :allow_destroy => true
  <%- end -%>
<%- end -%>
  
end