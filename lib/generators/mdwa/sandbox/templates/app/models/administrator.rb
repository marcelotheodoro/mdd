# -*- encoding : utf-8 -*-
class Administrator < User
  after_create :create_super_admin_permission
  
  def create_super_admin_permission
    self.permissions.push Permission.find_by_name("SuperAdmin")
  end
  
end
