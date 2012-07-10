class Create<%= @model.plural_name.camelize %> < ActiveRecord::Migration

	def self.up
		create_table :<%= @model.plural_name %> do |t|
		<%- @model.simple_attributes.each do |attr| -%>
			t.<%= attr.migration_field %> :<%= attr.name %>
		<%- end -%>
		<%- unless options.skip_timestamps -%>
			t.timestamps 
		<%- end -%>
		end
	end

	def self.down 
		drop_table :<%= @model.plural_name %>
	end

end