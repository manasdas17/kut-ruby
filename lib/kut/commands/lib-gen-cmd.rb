require 'ostruct'

module Kut
  class LibraryGeneratorCommand
    attr_reader :name
    attr_reader :help_banner
    
    def initialize
      @name = 'lib-gen'
      @help_banner = 'Generate schema library'
    end
    
    def help
      'help for lib-gen command'
    end    
    
    def run(args)
      
      options = OpenStruct.new
      
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: kut #{self.name} [options]"
        opts.on("-G", "--generator GENERATOR_NAME", "Select generator") do |gen_name|
        end
      end
      opts.parse!(args)
      
      
    end
  end
end