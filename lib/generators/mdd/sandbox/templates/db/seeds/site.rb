# -*- encoding : utf-8 -*-
if Administrator.count == 0
	Permission.create( :name => "SuperAdmin" ) if Permission.find_by_name("SuperAdmin").nil?
	Administrator.create :name => "Administrator", :email => 'admin@admin.com', :password => 'admin123', :password_confirmation => 'admin123'
end