require 'test/unit'
require 'kut/library/components'
require 'kut/library/regexp'

class LibraryCmpPin_Test < Test::Unit::TestCase
  
  def test_default_initialize
    assert(Kut::Library::Pin.new.to_s() =~  Kut::Library::RegExp::PIN_EXP)
  end
  
  def test_initialize
    assert(Kut::Library::Pin.new(:name => 'PL2303', :orientation => 'U').to_s() =~  Kut::Library::RegExp::PIN_EXP)
    assert($1 == 'PL2303')
    assert($6 == 'U')
  end
end