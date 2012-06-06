class <%= @model.controller_name %>Controller < <%= @inherit_controller || 'ApplicationController' %>

	def index
		@<%= @model.plural_name %> = <%= @model.klass %>.paginate :page => params[:page]

	    respond_to do |format|
	      format.html
	      format.js
	    end
	end


	def show
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])

	    respond_to do |format|
	      format.html
	    end
	end

	def new
	    @<%= @model.singular_name %> = <%= @model.klass %>.new

	    respond_to do |format|
	      format.html
	    end
	end

	def edit
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
	end

	def create
	    @<%= @model.singular_name %> = <%= @model.klass %>.new(params[:<%= @model.object_name %>])

	    respond_to do |format|
	      if @<%= @model.singular_name %>.save
	        format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: t('<%= @model.plural_name %>.create_success') }
	      else
	        format.html { render action: "new" }
	      end
	    end
	end

	def update
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
	    
	    respond_to do |format|
	      if @<%= @model.singular_name %>.update_attributes(params[:<%= @model.object_name %>])
	        format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: t('<%= @model.plural_name %>.update_success') }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
	    
	    @<%= @model.singular_name %>.destroy
	    
	    respond_to do |format|
	      format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: t('<%= @model.plural_name %>.destroy_success') }
	    end
	end

end