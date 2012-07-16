# -*- encoding : utf-8 -*-
class Create<%= @association.ordered.first.plural_name.camelize %><%= @association.ordered.last.plural_name.camelize %> < ActiveRecord::Migration
	def change
	    create_table :<%= @association.ordered.first.plural_name %>_<%= @association.ordered.last.plural_name %>, :id => false do |t|
	      t.references :<%= @association.ordered.first.singular_name %>, :<%= @association.ordered.last.singular_name %>
	    end
  	end
end