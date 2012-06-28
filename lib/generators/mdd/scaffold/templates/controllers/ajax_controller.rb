class <%= @model.controller_name %>Controller < <%= @inherit_controller || 'ApplicationController' %>
  
  load_and_authorize_resource :class => "<%= @model.klass %>"

	def index
		@<%= @model.plural_name %> = <%= @model.klass %>.paginate :page => params[:page]

	    respond_to do |format|
	      format.html
	      format.js
	    end
	end


	def show
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
	    render :layout => false
	end

	def new
	    @<%= @model.singular_name %> = <%= @model.klass %>.new
	    <%- @model.attributes.select {|a| a.nested_one?}.each do |attr| -%>
	    @<%= @model.singular_name %>.<%= attr.type.singular_name %> = <%= attr.type.klass %>.new
	    <%- end -%>
		  render :layout => false
	end

	def edit
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
		  render :layout => false
	end

	def create
	    @<%= @model.singular_name %> = <%= @model.klass %>.new(params[:<%= @model.object_name %>])
	    @system_notice = t('<%= @model.plural_name %>.create_success') if @<%= @model.singular_name %>.save
	    # loads all <%= @model.plural_name %> to display in the list
	    load_list

	    respond_to do |format|
	      format.js
	    end
	end

	def update
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
	    @system_notice = t('<%= @model.plural_name %>.update_success') if @<%= @model.singular_name %>.update_attributes(params[:<%= @model.object_name %>])
	    
	    # loads all <%= @model.plural_name %> to display in the list
	    load_list

	    respond_to do |format|
	      format.js
	    end
	end

	def destroy
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
	    @system_notice = t('<%= @model.plural_name %>.destroy_success') if @<%= @model.singular_name %>.destroy

	    # loads all <%= @model.plural_name %> to display in the list
	    load_list

	    respond_to do |format|
	      format.js
	    end
	end

	private
		def load_list
			@<%= @model.plural_name %> = <%= @model.klass %>.paginate :page => 1
		end

end