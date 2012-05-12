class A::BackendController < ApplicationController

	before_filter :authenticate_a_user!

	check_authorization
  	load_and_authorize_resource

	def current_ability
	  @current_ability ||= Ability.new(current_user)
	end

	def current_user
		return current_a_user
	end
	helper_method :current_user
end