require 'kut/application'

module Kut
  class HelpCommand
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'help'
      @help_banner = 'Help for information on a specific command.'
    end
    
    def help(args)
      @help_banner
    end    
    
    def show_cmd_help(cmd_name, args)
      cmd = Kut.application.command_by_name(cmd_name)
      puts cmd.help(args) if cmd
      puts "Help for command #{cmd_name} not found." unless cmd
      exit
    end
    
    def run(args)
      Kut.application.show_help() unless args
      Kut.application.show_help() if args.size() == 0
      help_args = args.dup()
      help_args.delete_at(0)
      show_cmd_help(args[0], help_args)
    end
  end
end