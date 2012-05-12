module Mdd
	module Layout

		module Helper
			def select_layout
		      	Layout.new.select_layout "#{request.path_parameters[:controller]}##{request.path_parameters[:action]}"
		    end
		end

	end
end