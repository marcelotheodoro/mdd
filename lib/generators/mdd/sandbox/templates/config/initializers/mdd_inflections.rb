# -*- encoding : utf-8 -*-
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'permission', 'permissions'
  inflect.irregular 'permission_user', 'permissions_users'
end
