# -*- encoding : utf-8 -*-
class A::AdministratorsController < A::BackendController
  
  load_and_authorize_resource
  
  def index
    @administrators = Administrator.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @administrator = Administrator.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @administrator = Administrator.find(params[:id])
  end

  def edit_own_account
    @administrator = Administrator.find(current_user.id)
    render 'edit'
  end

  def create
    @administrator = Administrator.new(params[:administrator])

    respond_to do |format|
      if @administrator.save
        format.html { redirect_to a_administrators_path, notice: t('administrators.create_success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @administrator = Administrator.find(params[:id])
    # if password is blank, delete from params
    if params[:administrator][:password].blank?
      params[:administrator].delete :password
      params[:administrator].delete :password_confirmation
    end

    respond_to do |format|
      if @administrator.update_attributes(params[:administrator])
        format.html { redirect_to a_administrators_path, notice: t('administrators.update_success') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.json
  def destroy
    @administrator = Administrator.find(params[:id])

    if current_user.id == params[:id].to_i
      redirect_to a_administrators_path, notice: t('administrators.destroy_cant_delete_own_user')
      return false
    end
    
    @administrator.destroy
    
    respond_to do |format|
      format.html { redirect_to a_administrators_path, notice: t('administrators.destroy_success') }
    end
  end
end
