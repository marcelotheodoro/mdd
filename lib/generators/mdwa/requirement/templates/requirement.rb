# -*- encoding : utf-8 -*-
require 'mdwa/dsl'
MDWA::DSL.requirements.register do |r|
  
  r.summary     = '<%= @summary %>'
  r.alias       = '<%= @requirement.alias %>' # alias is the unique requirement name and it's created automatically, you can override it with this argument.
  r.description = %q{Detailed description of the requirement.}
  
  <%- unless options.no_comments %>
  #
  # Entities involved in this requirement.
  # Use an array of entity names.
  # r.entities    = ['ProjectGroup', 'Project']
  
  # 
  # Users involved in this requirement.
  # Use an array of user names.
  # r.users       = ['Administrator']
  <% end %>
    
end
