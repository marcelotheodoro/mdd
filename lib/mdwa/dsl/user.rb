# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class User
      
      attr_accessor :name, :description, :user_roles
      
      def initialize(name)
        self.name = name.camelize
        
        self.clear_user_roles
      end
      
      def user_roles
        @user_roles.uniq
      end
      
      def user_roles=(value)
        if value.is_a? Array
          @user_roles = @user_roles | value
        else 
          @user_roles = @user_roles | [value]
        end
      end
      
      def clear_user_roles
        @user_roles = [self.name]
      end
      
    end
    
  end
end
