class <%= namespace_scope %><%= plural_name.camelize %>Controller < <%= @inherit_controller || 'ApplicationController' %>

	def index
		@<%= plural_name %> = <%= namespace_model_class %>.paginate :page => params[:page]

	    respond_to do |format|
	      format.html
	      format.js
	    end
	end


	def show
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
	    render :layout => false
	end

	def new
	    @<%= singular_name %> = <%= namespace_model_class %>.new
		render :layout => false
	end

	def edit
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
		render :layout => false
	end

	def create
	    @<%= singular_name %> = <%= namespace_model_class %>.new(params[:<%= namespace_object %>])
	    @<%= singular_name %>.save
	    # loads all <%= plural_name %> to display in the list
	    load_list

	    respond_to do |format|
	      format.js
	    end
	end

	def update
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
	    @<%= singular_name %>.update_attributes(params[:<%= namespace_object %>])
	    
	    # loads all <%= plural_name %> to display in the list
	    load_list

	    respond_to do |format|
	      format.js
	    end
	end

	def destroy
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
	    @<%= singular_name %>.destroy

	    # loads all <%= plural_name %> to display in the list
	    load_list

	    respond_to do |format|
	      format.js
	    end
	end

	private
		def load_list
			@<%= plural_name %> = <%= namespace_model_class %>.paginate :page => 1
		end

end