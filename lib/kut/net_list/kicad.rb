require 'ostruct' 

module Kut
  module NetList
    class KiCadNetList
      def initialize(f_in = nil)
        @components = []
        load(f_in) if f_in
      end
      
      def load(f_in)
        cur_component = nil
        f_in.each_line { |line|
          #( /4A5F296D/4A5F296D con-yamaichi-cf-2-CF050P2  X4 CF050P2 {Lib=CF050P2}
          if mh = /^\s+\(\s+((?:\/[\dABCDEF]{8})+)\s+(\S*)\s+(\S*)\s+(\S*)\s+(?:\{Lib=(\S*)\})?\s*/.match(line)
            cur_component = OpenStruct.new
            cur_component.reference = mh[3]
            cur_component.footprint = mh[2]
            cur_component.value = mh[4]
            cur_component.name = mh[5]
            cur_component.nets = []
          end 
          
          if /^\s+\)/ =~ line
            @components << cur_component if cur_component
            cur_component = nil
          end
          
          if cur_component && (mh = /^\s+\(\s+(\S+)\s+(\S+)\s+\)/.match(line))
            cur_component.nets << { :net => mh[2], :pin => mh[1]} if cur_component 
          end
        }        
      end
      
      def by_components
        return @components
      end  
    end
  end # end module NetList  
end # end module Kut