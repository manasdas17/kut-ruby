require 'test/unit'
require 'kut/library/pins_reader'

class LibraryPinsReader_Test < Test::Unit::TestCase
  
  PINS_FILE = <<EOFS
#NAMES NAME1, NAME2 , NONAME 
#REF DA
1 VCC
2 GND  

#TOP
3 3PIN
#NO-PIN
4 4PIN

#LEFT
5 5PIN

#RIGHT
6 6PIN

#BOTTOM
S23 S23PIN
S1 S1PIN

EOFS
  
  def test_parse
    res = Kut::Library::PinsParser.parse(PINS_FILE)
    assert(res.reference == 'DA')
    assert(res.names == ['NAME1', 'NAME2', 'NONAME'], 'Names mismatch.')
    assert(res.other_pins == [['VCC', '1'], ['GND', '2']])
    assert(res.top_pins == [['3PIN', '3'], nil,  ['4PIN', '4']])
    assert(res.left_pins == [['5PIN', '5']])
    assert(res.right_pins == [['6PIN', '6']])
    assert(res.bottom_pins == [['S23PIN', 'S23'], ['S1PIN', 'S1']])
  end

end