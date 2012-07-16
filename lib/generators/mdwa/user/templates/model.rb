class <%= @model.klass %> < User
  
	attr_accessible <%= @model.simple_attributes.collect {|a| ":" + a.name }.join(', ') %>
	
	after_create :create_<%= @model.singular_name %>_permission

  def create_<%= @model.singular_name %>_permission
    self.permissions.push Permission.find_by_name("<%= @model.singular_name %>")
  end
  
end