# -*- encoding : utf-8 -*-
===entity_code===
class <%= @model.controller_name %>Controller < <%= (@model.space == 'a') ? 'A::BackendController' : 'ApplicationController' %>

  <%- if @entity.resource? -%>
  load_and_authorize_resource :class => "<%= @model.klass %>"
  <%- end -%>

	def index
	  @<%= @model.plural_name %> = <%= @model.klass %>.paginate :page => params[:page]

    respond_to do |format|
      format.html
      format.js
    end
	end


	def show
    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])

  <%- if @entity.ajax? -%>
    render :layout => false
  <%- else -%>
    respond_to do |format|
      format.html
    end
  <%- end -%>
	end

	def new
    @<%= @model.singular_name %> = <%= @model.klass %>.new
    <%- @model.attributes.select {|a| a.nested_one?}.each do |attr| -%>
    @<%= @model.singular_name %>.<%= attr.type.singular_name %> = <%= attr.type.klass %>.new
    <%- end -%>

  <%- if @entity.ajax? -%>
    render :layout => false
  <%- else -%>
    respond_to do |format|
      format.html
    end
  <%- end -%>
	end

	def edit
    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])

  <%- if @entity.ajax? -%>
    render :layout => false
  <%- else -%>
    respond_to do |format|
      format.html
    end
  <%- end -%>
	end

	def create
    @<%= @model.singular_name %> = <%= @model.klass %>.new(params[:<%= @model.to_params %>])
    
  <%- if @entity.ajax? -%>
    @system_notice = t('<%= @model.plural_name %>.create_success') if @<%= @model.singular_name %>.save
    load_list # loads all <%= @model.plural_name %> to display in the list
  <%- end -%>

    respond_to do |format|
    <%- if @entity.ajax? -%>
      format.js
    <%- else -%>  
      if @<%= @model.singular_name %>.save
        format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: t('<%= @model.plural_name %>.create_success') }
      else
        format.html { render action: "new" }
      end
    <%- end -%>
    end
	end

	def update
    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
  <%- if @entity.ajax? -%>
    @system_notice = t('<%= @model.plural_name %>.update_success') if @<%= @model.singular_name %>.update_attributes(params[:<%= @model.to_params %>])
    load_list # loads all <%= @model.plural_name %> to display in the list
  <%- end -%>
    
    respond_to do |format|
    <%- if @entity.ajax? -%>
      format.js
    <%- else -%>
      if @<%= @model.singular_name %>.update_attributes(params[:<%= @model.object_name %>])
        format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: t('<%= @model.plural_name %>.update_success') }
      else
        format.html { render action: "edit" }
      end
    <%- end -%>
    end
	end

	def destroy
    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
    @system_notice = t('<%= @model.plural_name %>.destroy_success') if @<%= @model.singular_name %>.destroy
  <%- if @entity.ajax? -%>
    load_list # loads all <%= @model.plural_name %> to display in the list
  <%- end -%>
    
    respond_to do |format|
    <%- if @entity.ajax? -%>
      format.js
    <%- else -%>
      format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: @system_notice }
    <%- end -%>
    end
	end
	
	
	private
		def load_list
			@<%= @model.plural_name %> = <%= @model.klass %>.paginate :page => 1
		end

end