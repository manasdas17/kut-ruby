module Kut
  class HelpCommand
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'help'
      @help_banner = 'help bunner'
    end
    
    def help
      'help for lib-gen command'
    end    
    
    def run(args)
    end
  end
end