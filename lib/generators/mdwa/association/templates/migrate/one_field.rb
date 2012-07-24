# -*- encoding : utf-8 -*-
class Add<%= @field.singular_name.foreign_key.camelize %>To<%= @table.plural_name.camelize %> < ActiveRecord::Migration

	def self.up
		add_column :<%= @table.plural_name %>, :<%= @field.singular_name.foreign_key %>, :integer
		add_index :<%= @table.plural_name %>, :<%= @field.singular_name.foreign_key %>
	end

	def self.down 
		remove_column :<%= @table.plural_name %>, :<%= @field.singular_name.foreign_key %>
		remove_index :<%= @table.plural_name %>, :<%= @field.singular_name.foreign_key %>
	end

end
