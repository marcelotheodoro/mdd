module MDWA
  module DSL
    
    class EntitySpecification
      
      attr_accessor :description, :details
      
      def initialize(description)
        self.description = description
        
        self.details = []
      end
      
      def such_as(detail)
        self.details << detail
      end
      
    end # class
    
  end # dsl
end # mdwa