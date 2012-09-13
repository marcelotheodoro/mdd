# -*- encoding : utf-8 -*-
class A::AdministratorsController < A::BackendController
  
  load_and_authorize_resource :class => 'A::Administrator'
  
  def index
    @administrators = A::Administrator.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @administrator = A::Administrator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @administrator = A::Administrator.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @administrator = A::Administrator.find(params[:id])
  end

  def edit_own_account
    @administrator = A::Administrator.find(current_user.id)
    render 'edit'
  end

  def create
    @administrator = A::Administrator.new(params[:a_administrator])

    respond_to do |format|
      if @administrator.save
        format.html { redirect_to a_administrators_path, notice: t('administrators.create_success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @administrator = A::Administrator.find(params[:id])
    # if password is blank, delete from params
    if params[:a_administrator][:password].blank?
      params[:a_administrator].delete :password
      params[:a_administrator].delete :password_confirmation
    end

    respond_to do |format|
      if @administrator.update_attributes(params[:a_administrator])
        format.html { redirect_to a_administrators_path, notice: t('administrators.update_success') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.json
  def destroy
    @administrator = A::Administrator.find(params[:id])

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
