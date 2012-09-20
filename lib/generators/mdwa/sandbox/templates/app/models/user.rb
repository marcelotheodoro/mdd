# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  has_and_belongs_to_many :permissions
  
  def has_permission?(permission)
    return !!self.permissions.find_by_name(permission.to_s.camelize)
  end
  
end
