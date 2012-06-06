class Create<%= @model.plural_name.camelize %> < ActiveRecord::Migration

	def self.up
		create_table :<%= @model.plural_name %> do |t|
		<%- @model_attributes.each do |attr| %>
			t.<%= attr.migration_field %> :<%= attr.name %><%- end %>
		end
		<%- indexed_attributes = @model_attributes.select {|m| m.references?} %> <%- if indexed_attributes.count > 0 %>
		add_index :<%= @model.plural_name %>, [<%= indexed_attributes.collect {|m| ":" + m.name }.join(', ') %>]
		<%- end %>
	end

	def self.down 
		drop_table :<%= @model.plural_name %>
	end

end