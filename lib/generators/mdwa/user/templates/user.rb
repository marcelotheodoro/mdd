# -*- encoding : utf-8 -*-
require 'mdwa/dsl'
MDWA::DSL.users.register '<%= @user %>' do |u|
  
  # Description of what this user does in the system.
  # u.description = 'Member of the programmers team.'
  
  # User roles
  # By default, the user name is already included by default.
  # u.user_roles = ['<%= @user %>']
  
end
