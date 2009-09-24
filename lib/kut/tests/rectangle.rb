require 'test/unit'
require 'misc/rectangle'

class Point_Test < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_compare
    assert(true, Point[1,2] == Point[1, 2])
    assert(true, Point[1,2] != Point[2, 2])
  end
  
  def test_sum
    assert(true, Point[-1,2] == (Point[0, 3] + Point[-1, -1]))
  end
  
  def test_sub
    assert(true, Point[1,4] == (Point[0, 3] - Point[-1, -1]))
  end  
end
