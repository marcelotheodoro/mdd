# -*- encoding : utf-8 -*-
Permission.create( :name => "SuperAdmin" ) if Permission.find_by_name("SuperAdmin").nil?

if A::Administrator.count.zero?
	A::Administrator.create :name => "Administrator", :email => 'admin@admin.com', :password => 'admin123', :password_confirmation => 'admin123'
end
