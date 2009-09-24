module Kut
  module Library
    class RegExp
      LIBRARY_EXP = /^EESchema-LIBRARY\sVersion\s+(\S+)\s+Date:\s+(.*)/
      CMPDEF_EXP = /^DEF\s(\S+)\s(\S+)\s\S+\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/
      ALIAS_EXP = /^ALIAS\s(.*)/
      FIELD_EXP = /^F(\d+)\s\"([^\"]*)\"\s(\d+)\s(\d+)\s(\d+)\s([HV])\s([VI])\s([LRCBT])\s([LRCBT])([IN]?)([BN]?)(?:\s\"([^\"]*)\")?/
      
      DRAW_EXP = /^Draw/
      
      PIN_EXP = /^X \s+ (\S+) \s+ (\S+) \s+ (-?\d+) \s+ (-?\d+) \s+ (\d+)\s([UDRL])\s(\d+)\s(\d+)\s(\d+)\s(\d+)\s(\S)(?:\s(\S*))/x
      
      DRAW_END_EXP = /^DrawEnd/
      CMPDEF_END_XEP = /^ENDDEF/
      LIBRARY_END_EXP = /#End Library/
    end
  end
end