# -*- encoding : utf-8 -*-
class Create<%= @ordered_models.first.plural_name.camelize %><%= @ordered_models.last.plural_name.camelize %> < ActiveRecord::Migration
	def change
	    create_table :<%= @ordered_models.first.plural_name %>_<%= @ordered_models.last.plural_name %>, :id => false do |t|
	      t.references :<%= @ordered_models.first.singular_name %>, :<%= @ordered_models.last.singular_name %>
	    end
  	end
end