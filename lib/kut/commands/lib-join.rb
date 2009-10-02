require 'ostruct'
require 'date'
require 'kut/library/regexp'

module Kut
  class LibJoin
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'lib-join'
      @help_banner = 'Join schema libraries'
      @generators = []
      
      @options = OpenStruct.new
      @options.in_file_names = ['-']
      @options.out_file_name = '-'
      @options.net_list_loader = Kut::NetList::KiCadNetList
      @options.separator = ';'
      
      @option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: kut #{self.name} [options]"
               
        opts.on("-i", "--input lib1, lib2, lib3", Array, "Input libraries. if - to use stdin.") do |file_names|
          @options.in_file_names = file_names
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
    
    
    def run(args)

      begin @option_parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        $stderr << "Unknow option #{e}\n"
        exit
      end
                        
      f_out = $stdout
      f_out = File.new(@options.out_file_name, 'w') if @options.out_file_name && @options.out_file_name != '-'
      dt = DateTime.now
      f_out << "EESchema-LIBRARY Version 2.0 #{dt.day}/#{dt.mon}/#{dt.year}-#{dt.hour}:#{dt.min}:#{dt.sec}\n"
      @options.in_file_names.each { |fn|
        f_in = nil
        f_in = $stdin if fn == '-'
        f_in = File.new(fn) if fn && fn != '-'        
        
        f_in.each_line { |line|
          f_out << line unless Library::RegExp::LIBRARY_EXP =~ line || Library::RegExp::LIBRARY_END_EXP =~ line
        }
      }
      
      f_out << "#EndLibrary\n"
            
    end
  end
end