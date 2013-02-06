# -*- encoding : utf-8 -*-
require 'mdwa/dsl'
MDWA::DSL.requirements.register do |r|
  
  r.summary     = '<%= @summary %>'
  #r.description = %q{Detailed description of the requirement.}
  #r.non_functional_description = %q{Explain the non-functional concerns involved in this requirement.}
  
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
