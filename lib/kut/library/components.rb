module Kut
  module Library
    
    class Field
      attr_accessor :number, :text, :pos, :dimension, :orientation
      attr_accessor :visibility, :hjustify, :vjustify, :italic, :bold, :name
      
      def initialize(params = {}) 
        #number, text, pos, dimension, orientation, visibility, hjustify, vjustify, italic, bold, name
        if Hash === params
          @number = params[:number] ? params[:number] : 0 
          @text = params[:text] ? params[:text] : 'TEXT'
          @pos = params[:pos] ? params[:pos] : [0, 0]
          @dimension = params[:dimension] ? params[:dimension] : 50
          @orientation = params[:orientation] ? params[:orientation] : 'H'
          @visibility = params[:visibility] ? params[:visibility] : 'V'
          @hjustify = params[:hjustify] ? params[:hjustify] : 'C'
          @vjustify = params[:vjustify] ? params[:vjustify] : 'C'
          @italic = params[:italic] ? params[:italic] : 'N'
          @bold = params[:bold] ? params[:bold] : 'N'
          @name = params[:name] ? params[:name] : nil
        end
        #TODO implement raise exception
      end      
                
      def to_s
        __name = @name ? "\"#{@name}\"" : ''        
        "F#{@number} \"#{@text}\" #{@pos[0]} #{@pos[1]} #{@dimension} #{@orientation} #{@visibility} #{@hjustify} #{@vjustify}#{@italic}#{@bold} #{__name}\n"      
      end
    end    
    
    #Implementation of Pin component 
    class Pin
      attr_accessor :name, :number, :pos, :length
      attr_accessor :orientation, :snum, :snom, :unit, :convert, :etype
      
      #Parametrs name, number, pos, length, orientation, snum, snom, unit, convert, etype
      #Example creation: Pin.new(:name => 'PL2303', :orientation => 'U', :pos => [15, 24])
      def initialize(params = {}) #name, number, posx, posy, length, orientation, snum, snom, unit, convert, etype
        if Hash === params
          @name = params[:name] ? params[:name] : '~' 
          @number = params[:number] ? params[:number] : '0'
          @pos = params[:pos] ? params[:pos] : [0, 0]
           @length = params[:length] ? params[:length] : 300
          @orientation = params[:orientation] ? params[:orientation] : 'R'
          @snum = params[:snum] ? params[:snum] : 40
          @snom = params[:snom] ? params[:snom] : 40
          @unit = params[:unit] ? params[:unit] : 0
          @convert = params[:convert] ? params[:convert] : 0
          @etype = params[:etype] ? params[:etype] : 'P'
        end
        #TODO implement raise exception
      end
            
      def to_s
        "X #{@name} #{@number} #{@pos[0]} #{@pos[1]} #{@length} #{@orientation} #{@snum} #{@snom} #{@unit} #{@convert} #{@etype}\n"
      end
    end
    
    class Text
      attr_accessor :orientation, :pos, :dimension, :unit, :convert, :text 
      

      def initialize(params = {}) #:orientation, :pos, :dimension, :unit, :convert, :text
        if Hash === params
          @orientation = params[:orientation] ? params[:orientation] : 0
          @pos = params[:pos] ? params[:pos] : [0, 0]
          @dimension = params[:dimension] ? params[:dimension] : 40
          @unit = params[:unit] ? params[:unit] : 0
          @convert = params[:convert] ? params[:convert] : 0
          @text = params[:text] ? params[:text] : ''
        end
        #TODO implement raise exception
      end
            
      def to_s
        "T #{@orientation} #{@pos[0]} #{@pos[1]} #{@dimension} 0 #{@unit} #{@convert} #{@text}\n"
      end
    end    
    
    class Polygon
      attr_accessor :parts, :convert, :ltrait
      attr_accessor :points, :cc
      
      def initialize(params = {}) #:parts, :convert, :ltrait, :points, :cc
        if Hash === params
          @parts = params[:parts] ? params[:parts] : 0
          @points = params[:points] ? params[:points] : []
          @convert = params[:convert] ? params[:convert] : 0
          @ltrait = params[:ltrait] ? params[:ltrait] : 0
          @cc = params[:cc] ? params[:cc] : 'N'
        end
        #TODO implement raise exception
      end      
      
      def to_s
        result = "P #{@points.length} #{@parts} #{@convert} #{@ltrait}"
        @points.each { |point|
          result += " #{point[0]} #{point[1]}"
        }
        result += " #{@cc}\n"
      end
    end
        
    class Rectangle
      attr_accessor :start, :end, :unit, :convert, :ltrait, :cc
      
      def initialize(params = {}) #:start, :end, :unit, :convert, :ltrait, :cc
        if Hash === params
          @start = params[:start] ? params[:start] : [0, 0]
          @end = params[:end] ? params[:end] : [0, 0]
          @unit = params[:unit] ? params[:unit] : 0
          @convert = params[:convert] ? params[:convert] : 0
          @ltrait = params[:ltrait] ? params[:ltrait] : 0
          @cc = params[:cc] ? params[:cc] : 'N'
        end
        #TODO implement raise exception
      end
            
      def to_s
        "S #{@start[0]} #{@start[1]} #{@end[0]} #{@end[1]} #{@unit} #{@convert} #{@ltrait} #{@cc}\n"
      end    
    end 
       
    class Component
      attr_accessor :name, :reference, :text_offset, :draw_pinnumber, :draw_pinname 
      attr_accessor :unit_count, :units_locked, :option_flag
      attr_accessor :alias, :fields, :draws
      
      def initialize(params = {})
        if Hash === params
          @name = params[:name] ? params[:name] : '' 
          @reference = params[:reference] ? params[:reference] : 'U'
          @text_offset = params[:text_offset] ? params[:text_offset] : 30
          @draw_pinnumber = params[:draw_pinnumber] ? params[:draw_pinnumber] : 'Y'
          @draw_pinname = params[:draw_pinname] ? params[:draw_pinname] : 'Y'
          @unit_count = params[:unit_count] ? params[:unit_count] : 1
          @units_locked = params[:units_locked] ? params[:units_locked] : 'F'
          @option_flag = params[:option_flag] ? params[:option_flag] : 'N'
          @alias = params[:alias] ? params[:alias] : []
          @fields = params[:fields] ? params[:fields] : []
          @draws = params[:draws] ? params[:draws] : []          
        end
        #TODO implement raise exception
      end      
      
      def to_s
        result = "DEF #{@name} #{@reference} 0 #{@text_offset} #{@draw_pinnumber} #{@draw_pinname} #{@unit_count} #{@units_locked} #{@option_flag}\n"
        result += "ALIAS"
        @alias.each { |nm| result += " #{nm}" } if @alias
        result += "\n"
        
        @fields.each { |field| result += "#{field.to_s}" } if @fields
        
        result += "DRAW\n"
        
        @draws.each { |draw| result += "#{draw.to_s}" } if @draws
        
        result += "ENDDRAW\n"
        
        result += "ENDDEF\n"
      end
          
    end    
    
  end  # end module Library
end # end module Kut