module Mdd
	module Generators
		class Model

			attr_accessor :name, :namespace

			def initialize( arg )
				# sets the variables by the string
				self.namespace = '' # prevents unitialized variable errors
				self.namespace = arg.split('/').first.camelize if arg.split('/').count > 1
        		self.name = arg.split('/').last.singularize.camelize
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

			private 
				def namespace_scope
		          return "#{namespace}::" if namespace?
		          return ''
		        end

		end
	end
end