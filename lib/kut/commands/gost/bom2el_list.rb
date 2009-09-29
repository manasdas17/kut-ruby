require 'ostruct'
require 'kut/net_list/kicad'
require 'kut/net_list/pcad'
require 'csv'

module Kut
  class Bom2EL
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'gs-bom2el'
      @help_banner = 'Generate list of elements from bill of materials'
      @generators = []
      
      @options = OpenStruct.new
      @options.in_file_name = '-'
      @options.out_file_name = '-'
      @options.separator = ';'
      
      @option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: kut #{self.name} [options]"
               
        opts.on("-i", "--input INPUT_FILE", "Innput pins file. if - to use stdin.") do |file_name|
          @options.in_file_name = file_name
        end
        
        opts.on("-o", "--output OUTPUT_FILE", "Output libary file. if - to use stdout.") do |file_name|
          @options.out_file_name = file_name
        end   
        
      end
      
    end
        
    def help(args)
      @option_parser.parse!(args)
      @option_parser.to_s()
    end    
    
    
    # 
    def join_ref(ref_list)
      return '' unless ref_list
      
      ref_list.sort! { |a, b|
        a =~ /(\D+)(\d*)/
        a_n = $1
        a_val = $2 ? $2.to_i : -1
        b =~ /(\D+)(\d*)/
        b_n = $1
        b_val = $2 ? $2.to_i : -1
        
        res = a_n <=> b_n
        res = a_val <=> b_val if res == 0
        res
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
    
    def gs_bom2el(f_in, f_out)
      
      sep = @options.separator
     
      first_line = true
      header = nil
      rows = []
     
      f_in.each_line { |line|
        row = CSV.parse_line(line, sep)
        header = row if first_line
        rows << row unless first_line
        first_line = false if first_line
      }
          
      footprint_index = header.index("footprint")
      ref_index = header.index("ref")
      value_index = header.index("value")
      
      groups = {}
      
      rows.each { |row|
        gr_id = "#{row[value_index]} #{row[footprint_index]}"
        group = groups[gr_id]
        unless group
          group = [] 
          groups[gr_id] = group
        end
        group << row[ref_index].to_s
      }
      
      result = []
      
      groups.each { |key, value|
        count = value.size()
        refs = join_ref(value)
        result << "#{refs}#{sep}#{key}#{sep}#{count}\n" 
      }      
      
      result.sort!
      f_out << "refs#{sep}type#{sep}count\n"
      result.each { |v| f_out << v }
    end
    
    def run(args)

      begin @option_parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        $stderr << "Unknow option #{e}\n"
        exit
      end
                        
      f_in = $stdin
      f_in = File.new(@options.in_file_name) if @options.in_file_name && @options.in_file_name != '-'
      f_out = $stdout
      f_out = File.new(@options.out_file_name, 'w') if @options.out_file_name && @options.out_file_name != '-'
      
      gs_bom2el(f_in, f_out)
      
    end
  end
end