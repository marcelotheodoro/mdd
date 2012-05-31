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

	    respond_to do |format|
	      format.html
	    end
	end

	def new
	    @<%= singular_name %> = <%= namespace_model_class %>.new

	    respond_to do |format|
	      format.html
	    end
	end

	def edit
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
	end

	def create
	    @<%= singular_name %> = <%= namespace_model_class %>.new(params[:<%= namespace_object %>])

	    respond_to do |format|
	      if @<%= singular_name %>.save
	        format.html { redirect_to <%= namespace_object.pluralize %>_path, notice: t('<%= plural_name %>.create_success') }
	      else
	        format.html { render action: "new" }
	      end
	    end
	end

	def update
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
	    
	    respond_to do |format|
	      if @<%= singular_name %>.update_attributes(params[:<%= namespace_object %>])
	        format.html { redirect_to <%= namespace_object.pluralize %>_path, notice: t('<%= plural_name %>.update_success') }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    @<%= singular_name %> = <%= namespace_model_class %>.find(params[:id])
	    
	    @<%= singular_name %>.destroy
	    
	    respond_to do |format|
	      format.html { redirect_to <%= namespace_object.pluralize %>_path, notice: t('<%= plural_name %>.destroy_success') }
	    end
	end

end