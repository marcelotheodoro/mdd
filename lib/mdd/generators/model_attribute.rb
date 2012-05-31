module Mdd
	module Generators

		class ModelAttribute
			attr_accessor :name, :type, :reference, :reference_type

			STATIC_TYPES = [:boolean, :date, :datetime, :decimal, :float, :integer, :string, :text, :time, :timestamp]

			def initialize( arg )

				# sets the variables by the string
				split = arg.split(':')
				self.type = split[1] 
				self.name = split[0]
				self.reference = split[2]
				self.reference_type = split[3]

			end

			def references?
				!STATIC_TYPES.include?(self.type.to_sym)
			end

			def name=(value)
				if references? and !value.end_with?('_id')
					@name = "#{value}_id" 
				else
					@name = value
				end
			end

			def form_field
		        @form_field ||= case self.type.to_sym
		          when :integer              then :number_field
		          when :float, :decimal      then :text_field
		          when :time                 then :time_select
		          when :datetime, :timestamp then :datetime_select
		          when :date                 then :date_select
		          when :text                 then :text_area
		          when :boolean              then :check_box
		          else
		            :text_field
		        end

		        "<%= f.#{@form_field} :#{self.name} %>"
			end
			
		end

	end
end