# -*- encoding : utf-8 -*-
===entity_code===
class <%= @model.controller_name %>Controller < <%= (@model.space == 'a') ? 'A::BackendController' : 'ApplicationController' %>

  <%- if @entity.resource? -%>
  load_and_authorize_resource :class => "<%= @model.klass %>"
  <%- end -%>
  
  # Hook for code generations. Do not delete.
  #===controller_init===

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
    saved_ok = @<%= @model.singular_name %>.save
    @system_notice = t('<%= @model.plural_name %>.create_success') if saved_ok    
  <%- if @entity.ajax? -%>
    load_list # loads all <%= @model.plural_name %> to display in the list
  <%- end -%>
  
  <%- @model.associations.select{|a| a.has_and_belongs_to_many? and a.composition?}.each do |association| -%>
    unless params[:<%= association.model2.plural_name %>].nil?
      @<%= @model.singular_name %>.<%= association.model2.plural_name %>.clear
      params[:<%= association.model2.plural_name %>].each do |<%= association.model2.singular_name.foreign_key %>|
        @<%= @model.singular_name %>.<%= association.model2.plural_name %>.push <%= association.model2.klass %>.find <%= association.model2.singular_name.foreign_key %>
      end
    end
  <%- end -%>

    respond_to do |format|
    <%- if @entity.ajax? -%>
      format.js
    <%- else -%>  
      if saved_ok
        format.html { redirect_to <%= @model.object_name.pluralize %>_path, notice: @system_notice }
      else
        format.html { render action: "new" }
      end
    <%- end -%>
    end
	end

	def update
    @<%= @model.singular_name %> = <%= @model.klass %>.find(params[:id])
  <%- if @entity.user? -%>
    # if password is blank, delete from params
    if params[:<%= @model.object_name %>][:password].blank?
      params[:<%= @model.object_name %>].delete :password
      params[:<%= @model.object_name %>].delete :password_confirmation
    end
  <%- end -%>
    saved_ok = @<%= @model.singular_name %>.update_attributes(params[:<%= @model.to_params %>])
  <%- if @entity.ajax? -%>
    @system_notice = t('<%= @model.plural_name %>.update_success') if saved_ok
    load_list # loads all <%= @model.plural_name %> to display in the list
  <%- end -%>
  
  <%- @model.associations.select{|a| a.has_and_belongs_to_many? and a.composition?}.each do |association| -%>
    unless params[:<%= association.model2.plural_name %>].nil?
      @<%= @model.singular_name %>.<%= association.model2.plural_name %>.clear
      params[:<%= association.model2.plural_name %>].each do |<%= association.model2.singular_name.foreign_key %>|
        @<%= @model.singular_name %>.<%= association.model2.plural_name %>.push <%= association.model2.klass %>.find <%= association.model2.singular_name.foreign_key %>
      end
    end
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