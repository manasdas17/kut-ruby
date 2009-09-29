require 'ostruct' 

module Kut
  module NetList
    class PCadNetList
      def initialize(f_in = nil)
        @components = []
        load(f_in) if f_in
      end
      
      def load(f_in)
        components = {}
        cur_cmp = nil
        cur_net = nil
        f_in.each_line { |line|
            
          if mh = /^\s*\(compInst\s*\"([^\"]*)\"/.match(line) 
            ref = mh[1]
            cur_cmp = components[ref]
            unless cur_cmp then
              cur_cmp = OpenStruct.new
              cur_cmp.reference = ref
              cur_cmp.nets = []
              components[ref] = cur_cmp  
            end
          end
          
          if (mh = /^\s*\(compValue\s*\"([^\"]*)\"/.match(line)) && cur_cmp
            cur_cmp.value = mh[1]
          end

          if (mh = /^\s*\(originalName\s*\"([^\"]*)\"/.match(line)) && cur_cmp
            cur_cmp.footprint = mh[1]
          end

          #(originalName "IDC2.54-V16C")
          
          if mh = /^\s*\(net\s\"([^\"]*)\"/.match(line)
            cur_net = mh[1]
          end
          
          if (mh = /^\s*\(node\s+\"([^\"]*)\"\s+\"([^\"]*)\"\s*\)/.match(line)) && cur_net
            ref = mh[1]
            cmp = components[ref]
            unless cmp then
              cmp = OpenStruct.new
              cmp.reference = ref
              cmp.nets = []
              components[ref] = cmp  
            end
            
            cmp.nets << {:net => cur_net, :pin => mh[1]}
          end
          
          if /^\s*\)/ =~ line
            cur_cmp = nil
            cur_net = nil
          end          
        }
        
        @components = components.values
      end
      
      def by_components
        return @components
      end  
    end
  end # end module NetList  
end # end module Kut