# -*- encoding : utf-8 -*-
require 'mdwa/dsl'
MDWA::DSL.workflow.register '<%= @description %>' do |p|
  
  p.alias       = '<%= @process.alias %>'
  
  <%- unless options.no_comments -%>
  # The process start point for every user role
  # Params: :user_role, alias or entity listing
  # p.start_for 'ProjectManager', 'new_project_group'
  # p.start_for 'TeamMember', 'new_task'
  
  # p.detail "Create project group" do |d|

    # Unique alias for detailing
    # Default: Detail name underscored
    # d.alias = 'create_project_group'
    
    # Roles with permission to execute this action
    # Default: all -> no restriction
    # d.user_roles ['ProjectManager']
    
    # Refered action
    # Params: 
    # => :alias
    # => :entity
    # => :action
    # => :method        => :get (default), :post, :put, :delete
    # => :request_type  => :html (default), :ajax, :ajax_js, :modalbox
    # d.action 'project_group', 'create'
    
    # Possible next action
    # Params: 
    # => :alias
    # => :entity
    # => :action
    # => :method
    # => :request
    # => :redirect  => boolean
    # => :render    => boolean
    # => :when - situation when it might occur
    # d.next_action 'new_project_group', :when => 'save failed'
    # d.next_action entity: 'project_group', action: 'index', :redirect => true, :when => 'save ok'
    # d.next_action 'project', 'new', :when => 'clicked save & new project'
        
  # end
  <%- end -%>
  
end
