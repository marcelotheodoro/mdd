# -*- encoding : utf-8 -*-
class Add<%= @model.attributes.collect{|a| a.name.camelize}.join('') %>ToUsers < ActiveRecord::Migration

	def self.up
		<%- @model.simple_attributes.each do |attr| -%>
			add_column :users, :<%= attr.name %>, :<%= attr.migration_field %>
		<%- end -%>
	end

	def self.down 
		<%- @model.simple_attributes.each do |attr| -%>
			remove_column :users, :<%= attr.name %>
		<%- end -%>
	end

end
