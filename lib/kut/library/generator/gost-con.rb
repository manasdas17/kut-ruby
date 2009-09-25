require 'kut/library/generator'
require 'kut/library/pins_reader'
require 'kut/library/components'

module Kut
  module Library
    
    class GOSTConnGenerator
      attr_reader :name
      
      def initialize
        @name = :gost_con
        @options = OpenStruct.new
        @options.pin_step = 100
      end
      
      def help
        'How to use this generator is help string'
      end
      #Preapare generator for generate library component 
      def prepare(args)
        opts = OptionParser.new do |opts|
          opts.banner = '' #"Usage: kut #{self.name} [options]"
          
          opts.on("--pin-step PIN_STEP", "Pin step in mils.") do |step|
            @options.pin_step = step.to_i()
          end
                              
          opts.on("--alias ALIAS", "Component alias.") do |al|
            @options.alias = al
          end   
                
          opts.on("--name NAME", "Component name.") do |name|
            @options.name = name
          end
          
          opts.on("--ref REFERENCE", "Component reference.") do |ref|
            @options.reference = ref
          end
        end
        opts.parse!(args)
        opts
      end
                
      #Generate library component
      #in_f input file
      #out_f output file
      def generate(in_f, out_f)
        pins_desc = Kut::Library::PinsParser.parse(in_f)
        all_pins = pins_desc.other_pins + pins_desc.left_pins + 
          pins_desc.right_pins + pins_desc.top_pins + pins_desc.bottom_pins
        all_pins.compact! # may be to contain nil
        all_pins.sort! { |x,y| Integer(x[1]) <=> Integer(y[1]) }
        
        max_length = [4, 5] # цепь, конт.  
        all_pins.each { |pin| 
          max_length[0] = [pin[0].size, max_length[0]].max 
          max_length[0] = [pin[0].size, max_length[0]].max
        }
        
        font_size = 60
        
        step = @options.pin_step 
        
        y_size = all_pins.length*step + step
        x_size = (max_length[0] + max_length[1] + 4)*font_size
        
        cmp_name = pins_desc.names[0] if pins_desc.names && pins_desc.names.size() > 0
        cmp_name = @options.name if @options.name
        cmp_ref = pins_desc.reference
        cmp_ref = @options.reference if @options.reference
        
        cmp_alias = pins_desc.names[1 .. pins_desc.names.size - 1] if pins_desc.names && pins_desc.names.size > 1
        cmp_alias = @options.alias if @options.alias
        
        component = Component.new(:name => cmp_name, :reference => cmp_ref, 
          :draw_pinname => 'N', :draw_pinnumber=> 'N', :text_offset => 0)
        component.alias = cmp_alias
        component.draws << Rectangle.new(:start => [0, step + step /2], :end => [x_size, -y_size + step + step /2])
        x = (max_length[1] + 2)*font_size
        component.draws << Polygon.new(:points => [[x, step + step /2], [x, -y_size + step + step /2]])
        
        component.fields << Field.new(:number => 0, :text => cmp_ref, :pos => [x, step + step /2 + 50])
        component.fields << Field.new(:number => 1, :text => cmp_name, :pos => [x, -y_size / 2 + 100], :visibility => 'I')
          
           
        y = step
        pin_num_x = (max_length[1] + 2)*font_size / 2
        component.draws << Text.new(:text => 'Конт.', :pos => [pin_num_x, y])
        pin_name_x = (max_length[1] + 2)*font_size + (max_length[0] + 2)*font_size / 2
        component.draws << Text.new(:text => 'Цепь', :pos => [pin_name_x, y])
                  
        x, y = 0, 0
        pin_len = 300
        all_pins.each { |pin|
          component.draws << Pin.new(:name => pin[0], :number => pin[1], :pos => [x - pin_len, y], :orientation => 'R')
          pin_num_x = x + (max_length[1] + 2)*font_size / 2
          component.draws << Text.new(:text => pin[1], :pos => [pin_num_x, y])
          pin_name_x = x + (max_length[1] + 2)*font_size + (max_length[0] + 2)*font_size / 2
          component.draws << Text.new(:text => pin[0], :pos => [pin_name_x, y])
          component.draws << Polygon.new(:points => [[x, y + step/2], [x + x_size, y + step /2]])
          y -= step
        }
          
        component
      end
    end    
    
  end  # end module Library
end # end module Kut