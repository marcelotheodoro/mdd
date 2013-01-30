# -*- encoding : utf-8 -*-
class Mdwa::MDWAController < ApplicationController
  
  protected
      def restrict_to_development
        head(:bad_request) unless Rails.env.development?
      end
  
end
