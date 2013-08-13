# -*- encoding : utf-8 -*-
class Permission < ActiveRecord::Base

  attr_accessible :name

  has_and_belongs_to_many :user
  validates :name, :uniqueness => true

end
