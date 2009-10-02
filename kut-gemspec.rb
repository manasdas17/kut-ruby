KUT_VERSION = "0.1.1"

@spec = Gem::Specification.new do |s|
  s.name = 'kut'
  s.version = KUT_VERSION
  s.date = '2009-09-24'
  
  s.summary = 'KiCAD utils & tools for generation, manipulation KiCAD files.'
  s.email = 'lexaficus@list.ru'
  s.authors = ['Alexey Pavlyukov']
    
  s.bindir = "bin" # Use these for applications.
  s.executables = ["kut"]
  s.default_executable = "kut"    
    
  s.has_rdoc = false
  s.rdoc_options = ["--main", "README.rdoc", "--title", "GostFrames Documentation"]
  #s.extra_rdoc_files = ["README.rdoc", "LICENSE.rdoc"]  
  s.rdoc_options = ["--charset=utf-8"]
  s.require_paths = ["lib"]  
  s.files = Dir.glob("{examples,lib,data}/**/**/*") + ["Rakefile.rb"] + Dir.glob("{doc-src,.}/*.rdoc")
  s.test_files = Dir[ "test/*_test.rb" ]    
end