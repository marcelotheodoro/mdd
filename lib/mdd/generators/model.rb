module Mdd
	module Generators
		class Model

			attr_accessor :name, :namespace, :attributes

			# Sets the variables by the string
			# Format: <namespace>/<model>, the namespace is optional.
			def initialize( arg )
				
				self.namespace = '' # prevents unitialized variable errors
				self.namespace = arg.split('/').first.camelize if arg.split('/').count > 1
        		self.name = arg.split('/').last.singularize.camelize

        		self.attributes = []
			end

			def valid?
				name.underscore =~ /^[a-z][a-z0-9_\/]+$/
			end

			def klass
				namespace_scope + name
			end

			def controller_name
				namespace_scope + name.pluralize
			end

			def object_name
				space + '_' + singular_name
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