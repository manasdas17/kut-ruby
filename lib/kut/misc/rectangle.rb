class Rectangle
  attr_accessor :x, :y, :w, :h
  
  def initialize(x = 0, y = 0, w = 0, h = 0)
    @x = x
    @y = y
    @w = w
    @h = h
  end
  
  def &(rt)
  end
  
=begin
  return true if rect contains point pt
=end  
  def contains?(pt)
    pt.x.between?(@x, @x + w) && pt.y.between?(@y, @y + h)
  end  
end