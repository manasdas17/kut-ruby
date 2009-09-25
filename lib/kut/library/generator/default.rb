require 'kut/library/generator'
require 'kut/library/pins_reader'
require 'kut/library/components'

module Kut
  module Library
    
    class DefaultGenerator
      attr_reader :name
      
      def initialize
        @name = :default
        @options = OpenStruct.new
        @options.pin_step = 100
        @options.pin_space = 400
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
                
          opts.on("--pin-space PIN_SPACE","Pin space in mils.") do |space|
            @options.pin_space = space.to_i()
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
          
        left_pins = pins_desc.left_pins + pins_desc.other_pins
        bottom_pins = pins_desc.bottom_pins
        right_pins = pins_desc.right_pins
        top_pins = pins_desc.top_pins
                 
        pin_name_max_length = 0
        left_pins.each { |pin| pin_name_max_length = [pin[0].size, pin_name_max_length].max if pin }
        bottom_pins.each { |pin| pin_name_max_length = [pin[0].size, pin_name_max_length].max if pin }
        right_pins.each { |pin| pin_name_max_length = [pin[0].size, pin_name_max_length].max if pin }
        top_pins.each { |pin| pin_name_max_length = [pin[0].size, pin_name_max_length].max if pin }
        snom = 60
        
        step = @options.pin_step 
        space = @options.pin_space
        
        x_size = [top_pins.length-1, bottom_pins.length-1].max*step + 2*space
        y_size = [left_pins.length-1, right_pins.length-1].max*step + 2*space
        
        cmp_name = pins_desc.names[0] if pins_desc.names && pins_desc.names.size() > 0
        cmp_name = @options.name if @options.name
        cmp_ref = pins_desc.reference
        cmp_ref = @options.reference if @options.reference
        
        cmp_alias = pins_desc.names[1 .. pins_desc.names.size - 1] if pins_desc.names && pins_desc.names.size > 1
        cmp_alias = @options.alias if @options.alias
        
        component = Component.new(:name => cmp_name, :reference => cmp_ref)
        component.fields << Field.new(:number => 0, :text => cmp_ref, :pos => [x_size / 2, -y_size / 2 + 50])
        component.fields << Field.new(:number => 1, :text => cmp_name, :pos => [x_size / 2, -y_size / 2 - 50])
        component.alias = cmp_alias
        component.draws << Rectangle.new(:end => [x_size, -y_size])
        
        x, y = 0, -space
        pin_len = 300
        left_pins.each { |pin|
          component.draws << Pin.new(:name => pin[0], :number => pin[1], 
            :pos => [x - pin_len, y], :orientation => 'R') if pin
          y -= step
        }
        
        x, y = x_size, -space
        right_pins.each { |pin|
          component.draws << Pin.new(:name => pin[0], :number => pin[1], 
            :pos => [x + pin_len, y], :orientation => 'L') if pin
          y -= step
        }
        
         
        x, y = space, 0
        top_pins.each { |pin|
          component.draws << Pin.new(:name => pin[0], :number => pin[1], 
            :pos => [x, y + pin_len], :orientation => 'D') if pin
          x += step
        }
        
        x, y = space, -y_size
        bottom_pins.each { |pin|
          component.draws << Pin.new(:name => pin[0], :number => pin[1], 
            :pos => [x, y - pin_len], :orientation => 'U') if pin
          x += step
        }  
        
        component
      end
    end    
    
  end  # end module Library
end # end module Kut