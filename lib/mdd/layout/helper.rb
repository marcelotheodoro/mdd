# -*- encoding : utf-8 -*-

module MDD
	module Layout

		module Helper

			extend ActiveSupport::Concern

			def self.included(base)
				base.send :include, ClassMethods
			end

			module ClassMethods
				def select_layout
      		Base.select_layout "#{request.path_parameters[:controller]}##{request.path_parameters[:action]}"
		  	end
		  	
        def current_page
          "#{request.path_parameters[:controller].gsub('/', '_').underscore}_#{request.path_parameters[:action].underscore}"
        end
        
		  end
		end

	end
end