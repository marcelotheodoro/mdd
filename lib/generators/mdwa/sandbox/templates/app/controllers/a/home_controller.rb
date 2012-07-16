# -*- encoding : utf-8 -*-
class A::HomeController < A::BackendController
 
  skip_load_and_authorize_resource
  skip_authorization_check

  def index
  end
  
  def edit_own_account
    redirect_to "/a/#{current_user.type.underscore.split('/').last.pluralize}/#{current_user.id}/edit?static_html=1"
  end

end
