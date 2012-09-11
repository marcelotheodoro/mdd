# -*- encoding : utf-8 -*-
require 'mdwa/dsl'
MDWA::DSL.entities.register "<%= name.singularize.camelize %>" do |e|
  
  <%- if options.user -%>
  # NOTE: Users have the following attributes predefined (Devise defaults):
  # "email", "password", "password_confirmation", "encrypted_password", "name", "type", "reset_password_token", 
  # "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", 
  # "current_sign_in_ip", "last_sign_in_ip", "created_at", "updated_at"
  e.user        = true
  <%- end -%>
  
  <%- unless options.no_comments -%>
  # e.purpose   = %q{To-do} # what does this entity do?
  # e.resource  = true      # should it be stored like a resource?
  # e.ajax      = true      # scaffold with ajax?
  # e.user      = false     # is this entity a loggable user?
  # e.scaffold_name = 'a/<%= name.singularize.underscore %>' # mdwa sandbox specific code?
  # e.model_name = 'a/<%= name.singularize.underscore %>' # use specific model name? or different namespace?

  ##
  ## Define entity attributes
  ##
  # e.attribute 'name', 'string'
  # e.attribute 'category', 'integer'
  
  ##
  ## Define entity associations
  ##
  # e.association do |a|
  #   a.type = 'many_to_one'
  #   a.destination = 'Category' # entity name
  # end
  # 
  # e.association do |a|
  #   a.name = 'address' # specify a name for the associations
  #   a.type = 'one_to_one'
  #   a.destination = 'Address' 
  #   a.composition = true
  #   a.description = 'This entity has a composite address.'
  #   a.skip_views  = false
  # end

  ##
  ## Entity specifications. 
  ## Define restrictions and rules so this entity will work properly.
  ##
  # e.specify "fields should not be invalid" do |s|
  #    s.such_as "date should be valid"
  #    s.such_as "administrator must not be empty"
  #    s.such_as "description must not be empty"
  #  end
  #  e.specify "date should not be in the past"

  ##
  ## Entity actions. Define controller and routes for new operations with this entity.
  ##
  # e.member_action :publish, :get, :html
  # e.collection_action :export, :post, [:csv, :xml]
  # e.collection_action :report, :get, [:ajax]
  
  <%- end -%>
  
end

<%- unless options.requirement.blank? -%>
MDWA::DSL.entity('<%= name.singularize.camelize %>').in_requirements << '<%= options.requirement %>'
<%- end -%>