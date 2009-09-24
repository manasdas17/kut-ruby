require 'optparse'
require 'ostruct'

module Kut
  class Application
    #attr_accessor :option_parser, :options
    
    def initialize
      @option_parser = OptionParser.new
      @options = OpenStruct.new
    end
    
    def sub_applications
      @sub_applications = @sub_applications ? @sub_applications : []
    end
    
    def help
      'SubApplication list'
    end
    
    def get_subapplication_by_name(app_name)
      sub_app = nil
      sub_applications.each { |app|
        if app.name.to_s == app_name
          sub_app = app
          break 
        end
      } 
      return sub_app 
    end
    
    def run
      puts "Application run"
      if ARGV && ARGV.size() > 0 then
        if ['help', '--help', '-h'].include?(ARGV[0]) then
          if ARGV.size() > 1 && ARGV[0] == 'help' then
            sub_app = get_subapplication_by_name(ARGV[1])
            puts sub_app.help() if sub_app
            puts help() unless sub_app
          else
            puts help()
          end
        else
          sub_app = get_subapplication_by_name(ARGV[0])
          sub_app.run()
        end
      else
        puts help()
      end
     
    end
  end
end