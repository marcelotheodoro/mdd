class Create<%= plural_name.camelize %> < ActiveRecord::Migration

	def self.up
		create_table :<%= plural_name %> do |t|
		<%- @model_attributes.each do |attr| %> <%- if !attr.references? %>
			t.<%= attr.type %> :<%= attr.name %> <%- else %> 
			t.integer :<%= attr.name %> <%- end %>
		<%- end %>
		<%- indexed_attributes = @model_attributes.select {|m| m.references?} %> <%- if indexed_attributes.count > 0 %>
			add_index <%= indexed_attributes.collect {|m| ":" + m.name }.join(', ') %>
		<%- end %>
		end
	end

	def self.down 
		drop_table :<%= plural_name %>
	end

end