module Kut
  module Library
    
    #Generator concept
    class Generator
      attr_reader :name
      
      def initialize(name)
        @name = name
      end
      
      def help
        'How to use this generator is help string'
      end 
      
      #Generate library
      #Options for all generators: :no_lib_decl - output only components without library head and end
      #in_f input file
      #out_f output file
      def generate(in_f, out_f, options)
      end
    end
        
  end  # end module Library
end # end module Kut