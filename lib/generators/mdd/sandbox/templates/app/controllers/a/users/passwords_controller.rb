# -*- encoding : utf-8 -*-
class A::Users::PasswordsController < A::BackendController
  
  skip_load_and_authorize_resource
  skip_authorization_check

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[@user.class.name.underscore])
      sign_in(@user, :bypass => true)
      redirect_to a_root_path, :notice => "Password updated."
    else
      render :edit
    end
  end
end
