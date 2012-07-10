# -*- encoding : utf-8 -*-
class CreateUserPermissions < ActiveRecord::Migration
  def change
    create_table :permissions_users, :id => false do |t|
      t.references :permission, :user
    end
  end
end
