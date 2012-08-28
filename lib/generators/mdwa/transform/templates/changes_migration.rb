# -*- encoding : utf-8 -*-
class Alter<%= @entities.select{|e| e.resource?}.collect{|e| e.file_name.camelize}.join('') %><%= @random_migration_key %> < ActiveRecord::Migration
  
  def self.up
  <%- @changes.each do |change| -%>
    <%= change[:type] %> :<%= MDWA::Generators::Model.new(change[:entity].model_name).plural_name %>, :<%= change[:column] %> <%= ", :#{change[:attr_type]}" unless change[:attr_type].blank? %>
  <%- end -%>
  end
  
  def self.down
  <%- @changes.each do |change| -%>
    <%= inverse_migration_type change[:type] %> :<%= MDWA::Generators::Model.new(change[:entity].model_name).plural_name %>, :<%= change[:column] %> <%= ", :#{change[:attr_type]}" if inverse_migration_type(change[:type]) == 'add_column' %> <%= ", :#{change[:from]}" unless change[:from].blank? %>
  <%- end -%>
  end
  
end
