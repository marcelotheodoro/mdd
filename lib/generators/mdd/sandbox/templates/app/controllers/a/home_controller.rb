# -*- encoding : utf-8 -*-
class A::HomeController < A::BackendController
 
  skip_load_and_authorize_resource
  skip_authorization_check

  def index
  end

end
