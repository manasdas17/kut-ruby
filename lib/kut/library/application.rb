module Kut
  module Library
  
    class SubApplication
      attr_reader :name
      def initialize
        @name = :lib
      end
      
      def help
        'help for subapplication lib'
      end
    end
      
  end  # end module Library
end # end module Kut