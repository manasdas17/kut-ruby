require 'ostruct'
require 'kut/net_list/kicad'
require 'kut/net_list/pcad'

module Kut
  class NetList2Bom
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'net2bom'
      @help_banner = 'Generatr bill of materials from netlist'
      @generators = []
      
      @options = OpenStruct.new
      @options.in_file_name = '-'
      @options.out_file_name = '-'
      @options.net_list_loader = Kut::NetList::KiCadNetList
      @options.separator = ';'
      
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
        
        opts.on("-o", "--output OUTPUT_FILE", "Output libary file. if - to use stdout.") do |file_name|
          @options.out_file_name = file_name
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
      f_out = $stdout
      f_out = File.new(@options.out_file_name, 'w') if @options.out_file_name && @options.out_file_name != '-'
      
      net2bom(f_in, f_out)
      
    end
  end
end