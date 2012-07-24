# -*- encoding : utf-8 -*-
module MDWA
	module Generators
		class Model

			attr_accessor :name, :namespace, :attributes, :specific_model_name
      
      #
			# Sets the variables by the string
			# Format: <namespace>/<model>, the namespace is optional.
			#
			def initialize( arg )
				
				self.namespace = '' # prevents unitialized variable errors
				self.namespace = arg.split('/').first.camelize if arg.split('/').count > 1
    		self.name = arg.split('/').last.singularize.camelize

    		self.attributes = []
			end

			def valid?
				name.underscore =~ /^[a-z][a-z0-9_\/]+$/
			end
			
			def specific?
			  !specific_model_name.blank?
		  end
		  
		  def specific_model
		    return Model.new( specific_model_name ) if specific?
        return nil
	    end

			def klass
			  if !specific?
				  return (namespace_scope + name)
        else 
          return specific_model.klass
        end
			end
			
			#
      # Returns the associated model in app/models folder
      #
			def model_class
			 self.klass.classify.constantize
		  end

			def controller_name
				namespace_scope + name.pluralize
			end

			def object_name
				space + '_' + singular_name
			end
			
			def to_params
			  if !specific?
				  return object_name
        else 
          return singular_name
        end
		  end
			
			def to_route_object(prefix = '')
			  return "#{prefix}#{singular_name}" if !specific? or !namespace?
			  return "[ :#{space}, #{prefix}#{singular_name}]" if specific? and namespace?
		  end

			def raw
				klass.underscore
			end

			def singular_name
				name.underscore
			end

			def plural_name
				name.underscore.pluralize
			end

			def namespace?
				!namespace.blank?
			end

			def space
				namespace.underscore
			end

			def add_attribute(model_attribute)
				self.attributes << model_attribute
				model_attribute.model = self
			end

			def simple_attributes
				attributes.select{ |a| !a.references? }
			end

			private 
				def namespace_scope
          return "#{namespace}::" if namespace?
          return ''
        end

		end
	end
end
