module Kut
  module Library
    class Pin
      attr_accessor :name, :number, :pos, :length
      attr_accessor :orientation, :snum, :snom, :unit, :convert, :etype
      
      def initialize(params = {}) #name, number, posx, posy, length, orientation, snum, snom, unit, convert, etype)
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
  end
end