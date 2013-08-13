# -*- encoding : utf-8 -*-
class A::BackendController < ApplicationController

	before_filter :authenticate_a_user!
  before_filter :guardar_per_page

	check_authorization

	def current_ability
	  @current_ability ||= Ability.new(current_user)
	end

	def current_user
		return current_a_user
	end
	helper_method :current_user


  # Uma vez que se altere o per_page, ele vai pra sessão.
  # Isso facilita buscas globais e não perde o per_page em listas com filtros.
  def guardar_per_page
    if params[:per_page].blank?
      params[:per_page] = session[:per_page]
    else
      session[:per_page] = params[:per_page]
    end
  end


end
