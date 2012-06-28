module Mdd
	module Generators

		class ModelAttribute
			attr_accessor :name, :type, :reference, :reference_type, :model

			STATIC_TYPES = [:boolean, :date, :datetime, :decimal, :float, :integer, :string, :text, :time, :timestamp, :file]

			# Sets the attributes variables
			# Format: <name>:<type>||<model>:<reference>:<reference_type>
			def initialize( arg )

				# sets the variables by the string
				split = arg.split(':')
				self.type = split[1] 
				self.name = split[0]
				self.reference = split[2]
				self.reference_type = split[3]
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
          value_split = value.split(',')
					@type = Model.new( value_split.first ) # instance of model
          @type.specific_model_name = value_split.last if value_split.count > 1
					raise "Invalid reference type" if @type.nil?
				end
			end

			def reference=(value)
				@reference = value
				@reference = 'id' if value.blank?
			end

			def reference_type=(value)
				@reference_type = value.underscore unless value.blank?
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
			end

			def belongs_to?
				return (reference_type == 'belongs_to')
			end

			def has_many?
				return (reference_type == 'has_many')
			end

			def nested_many?
				return (reference_type == 'nested_many')
			end

			def nested?
				nested_many? || nested_one?
			end

			def nested_one?
				return (reference_type == 'nested_one')
			end

			def has_one?
				return (reference_type == 'has_one')
			end

			def has_and_belongs_to_many?
				return (reference_type == 'has_and_belongs_and_to_many')
			end

			def references?
				!STATIC_TYPES.include?(self.type.to_s.to_sym)
			end
		end

	end
end