require "#{File.dirname(__FILE__)}/../example_helper.rb"
require 'kut/net_list/kicad'
require 'kut/net_list/pcad'

#net_list = Kut::NetList::KiCadNetList.new($stdin)
net_list = Kut::NetList::PCadNetList.new($stdin)

cmp_list = net_list.by_components()

cmp_by_value = {}

cmp_list.each { |cmp|
  cmp_by_value[cmp.value] << cmp if cmp_by_value[cmp.value]
  cmp_by_value[cmp.value] = [cmp] unless cmp_by_value[cmp.value] 
  #puts "#{cmp.reference} #{cmp.value}"
}

cmp_list = {}

def join_ref(ref_list)
  return '' unless ref_list
  
  ref_list.sort! { |a, b|
    a =~ /(\D+)(\d+)/
    a_n = $1
    a_val = $2.to_i
    b =~ /(\D+)(\d+)/
    b_n = $1
    b_val = $2.to_i
    
    res = a_n <=> b_n
    res = a_val <=> b_val if res == 0
  }
   
  ref_list.first =~ /(\D+)(\d+)/
  prev_pref = $1
  prev_num = $2.to_i
  prev_ref = ref_list.first
  
  result = ref_list.first
  ref_list.delete_at(0)
  counter = 0
  
#  while ! ref_list.empty?
#    ref = ref_list.first
#    ref_list.delete_at(0)
#  end
  
  flag = false
  
  ref_list.each { |ref|
    ref =~ /(\D+)(\d+)/
    pref = $1
    num = $2.to_i
    
    flag = (pref == prev_pref) && (num == (prev_num + 1))
      
    if !flag then
      if counter != 0 then
        result += counter > 1 ? '..' : ','
        result += prev_ref + ',' + ref
      else
        result += ',' + ref
      end
    end
    
    #result += '..' + prev_ref + ',' + ref unless flag && counter != 0
    #result += ',' + ref unless flag
    
    counter += 1 if flag
    counter = 0 unless flag
    
    prev_pref = pref
    prev_num = num    
    prev_ref = ref
  }
  
  if flag && counter != 0 then
    result += counter > 1 ? '..' : ','
    result += prev_ref
  end 
  
  
  result
end  

result = []

cmp_by_value.each { |key, cmps|
  refs = []
  count = 0
  cmps.each { |cmp|
    refs << cmp.reference
    count += 1
  }
  refs = join_ref refs
  result << ";#{refs};#{key};#{count};"
}

result.sort!

result.each{ |v| puts v }