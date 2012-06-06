module Mdd
	module Generators

		class ModelAttribute
			attr_accessor :name, :type, :reference, :reference_type, :model

			STATIC_TYPES = [:boolean, :date, :datetime, :decimal, :float, :integer, :string, :text, :time, :timestamp, :file]

			def initialize( arg, model_class )

				# sets the variables by the string
				split = arg.split(':')
				self.type = split[1] 
				self.name = split[0]
				self.reference = split[2]
				self.reference_type = split[3]
				
				self.model = model_class
			end

			def name=(value)
				if references? and !value.end_with?('_id')
					@name = "#{value}_id" 
				else
					@name = value
				end
			end

			def type=(value)
				if STATIC_TYPES.include?( value.to_sym )
					@type = value
				else
					@type = Model.new value # instance of model
					raise "Invalid reference type" if @type.nil?
				end
			end

			def reference=(value)
				@reference = value
				@reference = 'id' if value.blank?
			end

			def references?
				!STATIC_TYPES.include?(self.type.to_s.to_sym)
			end

			def migration_field
				@migration_field ||= case self.type.to_s.to_sym
		          when :string, :file		 then 'string'
		          when :boolean              then 'boolean'
		          when :date 				 then 'date'
		          when :datetime             then 'datetime'
		          when :decimal, :float      then 'decimal'
		          when :text 				 then 'text'
		          when :time 				 then 'time'
		          when :timestamp 			 then 'timestamp'
		          else
		            'integer'
		        end
			end

			def form_field
				if !references?
			        @form_field ||= case self.type.to_s.to_sym
			          when :integer              then 'number_field'
			          when :float, :decimal      then 'text_field'
			          when :file				 then 'file_field'
			          when :time                 then 'time_select'
			          when :datetime, :timestamp then 'datetime_select'
			          when :date                 then 'date_select'
			          when :text                 then 'text_area'
			          when :boolean              then 'check_box'
			          else
			            'text_field'
			        end

			        "<%= f.#{@form_field} :#{self.name} %>"
			    else
			    	"<%= f.select :#{name}, options_for_select( #{type.klass}.order('#{reference} ASC').collect{ |c| [c.#{reference}, c.id] }, @#{model.singular_name}[:#{name}] ), :include_blank => '-- Select a #{name.humanize} --' %>"
			    end
			end
			
		end

	end
end