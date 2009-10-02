require 'rubygems'
require 'rake'
require 'rake/testtask'
require "rake/rdoctask"
require "rake/gempackagetask"
 
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

require 'kut-gemspec' 
 
Rake::GemPackageTask.new(@spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end