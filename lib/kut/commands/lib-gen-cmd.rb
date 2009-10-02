require 'ostruct'
require 'date'
require 'kut/library/generator/simple'
require 'kut/library/generator/default'
require 'kut/library/generator/gost-con'
module Kut
  class LibraryGeneratorCommand
    attr_reader :name
    attr_reader :help_banner
    attr_accessor :generators
    
    def initialize
      @name = 'gen-lib'
      @help_banner = 'Generate schema library'
      @generators = []
      
      @options = OpenStruct.new
      @options.in_file_name = '-'
      @options.out_file_name = '-'
      @options.generator_name = 'default'
      
      @option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: kut #{self.name} [options]"
        opts.on("-G", "--generator GENERATOR_NAME", "Select generator") do |gen_name|
          @options.generator_name = gen_name
        end
        
        opts.on("-i", "--input INPUT_FILE", "Innput pins file. if - to use stdin.") do |file_name|
          @options.in_file_name = file_name
        end
        
        opts.on("-o", "--output OUTPUT_LIBRARY_FILE", "Output libary file. if - to use stdout.") do |file_name|
          @options.out_file_name = file_name
        end   
        
        opts.on("--list", "List of avalaible generators") do
          $stderr << "Avalaible generators:\n" 
          generators.each { |gen|
            $stderr << "#{' ' * 3}#{gen.name}\n" 
          }
          exit
        end
      end
      add_default_generators
    end
    
    def add_default_generators
      generators << Kut::Library::DefaultGenerator.new
      generators << Kut::Library::SimpleGenerator.new
      generators << Kut::Library::GOSTConnGenerator.new
    end
    
    def find_generator(name)
      generators.each { |g| return g if g.name.to_s() == name }
      nil
    end
    
    def help(args)
      #args_cp = args.dup()
      @option_parser.parse!(args)
      gen = find_generator(@options.generator_name)
      gen_help = ''
      gen_help = gen.prepare(args).to_s() if gen
      @option_parser.to_s() + gen_help
    end    
    
    def run(args)
      args_cp = args.dup
      begin @option_parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        args = [(args_cp - args)[-1]] + args
      end
                  
      gen = find_generator(@options.generator_name)
      $stderr << "Generator '#{@options.generator_name}' not found.\n" unless gen
      exit unless gen
      
      f_in = $stdin
      f_in = File.new(@options.in_file_name) if @options.in_file_name && @options.in_file_name != '-'
      f_out = $stdout
      f_out = File.new(@options.out_file_name, 'w') if @options.out_file_name && @options.out_file_name != '-'
      
      dt = DateTime.now
      f_out << "EESchema-LIBRARY Version 2.0 #{dt.day}/#{dt.mon}/#{dt.year}-#{dt.hour}:#{dt.min}:#{dt.sec}\n"
      gen.prepare(args)
      f_out << gen.generate(f_in, f_out)
      
      if f_in == $stdin
        while ! f_in.eof?
          f_out << gen.generate(f_in, f_out)
        end
      end
      
      f_out << "#EndLibrary\n" 
    end
  end
end