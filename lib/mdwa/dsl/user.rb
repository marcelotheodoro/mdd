# -*- encoding : utf-8 -*-
module MDWA
  module DSL
    
    class User
      
      attr_accessor :name, :description, :user_roles
      
      def initialize(name)
        self.name = name.camelize
        
        self.user_roles = [self.name]
      end
      
      def user_roles
        @user_roles.uniq
      end
      
    end
    
  end
end