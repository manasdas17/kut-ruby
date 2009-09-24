class Point
  
  attr_accessor :x, :y
  
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end
  
  def Point.[](x = 0, y = 0)
    return Point.new(x, y)
  end
  
  def +(pt)
    return Point[@x + pt.x, @y + pt.y]
  end
  
  def -(pt)
    return Point[@x - pt.x, @y - pt.y]
  end
  
  def ==(pt)
    (pt.x == @x) && (pt.y == @y) ? true : false
  end  
end