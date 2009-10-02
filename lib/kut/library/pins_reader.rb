require 'ostruct' 
module Kut
  module Library
    
    class PinsParser
      
      def PinsParser.parse(in_f)
        result = OpenStruct.new
        result.left_pins = []
        result.right_pins = []
        result.top_pins = []
        result.bottom_pins = []
        result.other_pins = []
        result.reference = 'U'
        result.names = ['NONAME']        
        
        current_pin_list = result.other_pins
        
        in_f.each_line { |line|
          case line
          when /\A([^#]\S*)\s+(\S+).*/
            current_pin_list << [$2, $1]
          when /\A#NO-PIN\s*/
            current_pin_list << nil
          when /\A#TOP\s*/
            current_pin_list = result.top_pins
          when /\A#BOTTOM\s*/
            current_pin_list = result.bottom_pins
          when /\A#LEFT\s*/
            current_pin_list = result.left_pins  
          when /\A#RIGHT\s*/
            current_pin_list = result.right_pins
          when /\A#REF\s+(\S+)/
            result.reference = $1
          when /\A#NAMES\s+(.*)/
            str =$1.gsub(/\s+/, '')
            result.names = str.split(',')
          when /\A#ENDPINS\s*/
            break         
          end
        }
        
        result
      end
      
    end
    
  end # module Libary
end # module Kut