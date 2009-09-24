require 'kut/application'

module Kut
  #
  # Kut module singleton methods.
  #
  class << self
    # Current Kut Application
    def application
      @application ||= Kut::Application.new
    end
   
    # Set the current Kut application object.
    def application=(app)
      @application = app
    end  
  end   
end