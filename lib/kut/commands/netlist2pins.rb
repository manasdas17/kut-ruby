require 'ostruct'
require 'kut/net_list/kicad'
require 'kut/net_list/pcad'

module Kut
  class NetList2Pins
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'netlist2pins'
      @help_banner = 'Generate pins files from netlist'
      @generators = []
      
      @options = OpenStruct.new
      @options.in_file_name = '-'
      @options.out_file_name_pattern = '-'
      @options.net_list_loader = Kut::NetList::KiCadNetList
      @options.separator = ';'
      @options.filter = nil
      @options.alias_pattern = '#N_#R'
      
      @option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: kut #{self.name} [options]"
        
        opts.on("-f", "--format NET_LIST_FORMAT", "Netlist file format (kicad - default, pcad)") do |format|
          case format
          when 'pcad' then @options.net_list_loader = Kut::NetList::PCadNetList
          when 'kicad' then @options.net_list_loader = Kut::NetList::KiCadNetList
          else
            $stderr << "Netlist format #{format} isn't supported.\n"
            exit
          end
        end
        
        opts.on("-i", "--input INPUT_FILE", "Innput pins file. if - to use stdin.") do |file_name|
          @options.in_file_name = file_name
        end
        
        opts.on("-F", "--filter FILTER", "Component reference filter.") do |filter|
          @options.filter = filter
        end
        
        opts.on("-o", "--output OUTPUT_FILE_PATTERN", "Output pins filename pattern. if - to use stdout.") do |file_name_p|
          @options.out_file_name_pattern = file_name_p
        end   
        
        opts.on("-a", "--alias ALIAS_PATTERN", "Alias pattern.") do |alias_p|
          @options.alias_pattern = alias_p
        end
      end
      
    end
        
    def help(args)
      @option_parser.parse!(args)
      @option_parser.to_s()
    end    
    
    def net2bom(f_in, f_out)
      net_list = @options.net_list_loader.new(f_in)
      cmp_list = net_list.by_components()
      
      sep = @options.separator
      
      f_out << "ref#{sep}value#{sep}footprint\n"
      
      cmp_list.each{ |cmp|
        f_out << "#{cmp.reference}#{sep}#{cmp.value}#{sep}#{cmp.footprint}\n"
      }
    end
    
    def run(args)

      begin @option_parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        $stderr << "Unknow option #{e}\n"
        exit
      end
                        
      f_in = $stdin
      f_in = File.new(@options.in_file_name) if @options.in_file_name && @options.in_file_name != '-'
      
      net_list = @options.net_list_loader.new(f_in)
      cmp_list = net_list.by_components()
      
      filter = /^.*/ unless @options.filter
      filter = Regexp.new('^' + @options.filter.gsub!('*', '.*')) if @options.filter
      o_f_p = @options.out_file_name_pattern
      alias_p = @options.alias_pattern
      
      cmp_list.each { |cmp|
        next unless filter =~ cmp.reference
        o_f_n = o_f_p.gsub('#R', cmp.reference).
          gsub('#V', cmp.value).
          gsub('#N', cmp.name).
          gsub('#F', cmp.footprint).
          gsub('#I', @options.in_file_name)
        
        als = alias_p.gsub('#R', cmp.reference).
          gsub('#V', cmp.value).
          gsub('#N', cmp.name).
          gsub('#F', cmp.footprint).
          gsub('#I', @options.in_file_name)
            
        f_out = $stdout
        f_out = File.new(o_f_n, 'w') if o_f_n && o_f_n != '-'
        
        f_out << "#ALIAS #{als}\n"
        cmp.nets.each { |net|
          net_n = net[:net].gsub(/\/[\w\d]+\//, '').gsub('?', ' ')
          f_out << "#{net[:pin]} #{net_n}\n" 
        }
        
        f_out << "\n" if o_f_n == '-'
      }
      
    end
  end
end