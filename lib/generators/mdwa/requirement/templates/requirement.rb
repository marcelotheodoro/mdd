# -*- encoding : utf-8 -*-
require 'mdwa/dsl'
MDWA::DSL.requirements.register do |r|
  
  r.summary     = '<%= @summary %>'
  <%- unless options.no_comments %>
  # r.alias       = '<%= @requirement.alias %>' # alias is the unique requirement name and it's created automatically, you can override with this argument.
  # r.description = %q{Detailed description of the requirement.}
  
  #
  # Entities involved in this requirement.
  # Use an array of entity names.
  # r.entities    = ['ProjectGroup', 'Project', 'Task', 'Milestone']
  
  # 
  # Users involved in this requirement.
  # Use an array of user names.
  # r.users       = ['Administrator', 'TeamMember']
  <% end %>
    
end