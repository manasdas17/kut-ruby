require 'rubygems'
require 'rake'
require 'rake/testtask'
require "rake/rdoctask"
require "rake/gempackagetask"
 
KUT_VERSION = "0.1.0.0"
 
task :default => [:test]
       
desc "Run all tests"
Rake::TestTask.new do |test|
  test.libs << "lib"
  test.test_files = Dir[ "test/*_test.rb" ]
  test.verbose = true
end
 
desc "genrates documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README.rdoc",
                           "lib/",
                            Dir.glob("{doc-src,.}/*.rdoc"))
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "doc/html"
  rdoc.title = "Kut Documentation"
  rdoc.options = ['--charset=utf-8 --copy-local-images']
end
 
desc "run all examples"
task :examples do
  examples = Dir["examples/**/*.rb"]
  t = Time.now
  puts "Running Examples"
  examples.each { |file| `ruby -Ilib #{file}` }
  puts "Ran in #{Time.now - t} s"
end
 
spec = Gem::Specification.new do |s|
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
 
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end