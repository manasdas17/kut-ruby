require 'optparse'
require 'ostruct'

module Kut
  class Application
    attr_accessor :commands
    
    def initialize
      @option_parser = OptionParser.new
      @options = OpenStruct.new
      @commands = []
    end
        
    def show_help
      puts 'usage: kut [--help] COMMAND [ARGS]'
      puts 'The most commonly used kut commands are:'
      cmd_name_len = 10
      commands.each { |cmd|
        cmd_space = ' ' * (cmd_name_len - cmd.name.size)
        puts "#{' '*3}#{cmd.name}#{cmd_space}#{cmd.help_banner}"
      }
      exit
    end
    
    def command_by_name(cmd_name)
      cmd = nil
      commands.each { |c|
        if c.name == cmd_name
          cmd = c
          break 
        end
      } 
      return cmd 
    end
    
    def run_command(cmd_name, args)
      cmd = command_by_name(cmd_name)
      if cmd then
        cmd.run(args) 
      else
        puts "kut: #{cmd_name} is not a kut-command. See 'kut --help'"
        exit
      end
    end
    
    def run
      show_help() unless ARGV
      show_help() if ARGV.size() == 0
      show_help() if ['-h', '--help'].include?(ARGV[0])
      
      args = ARGV.dup()
      args.delete_at(0)
      run_command(ARGV[0], args)
    end
  end
end