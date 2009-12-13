require "rubygems"
require "rake"
require "rake/testtask"
require "rake/rdoctask"

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.title = "Ambience"
  rdoc.rdoc_dir = "rdoc"
  rdoc.rdoc_files.include("lib/**/*.rb")
  rdoc.options = ["--line-numbers", "--inline-source"]
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |spec|
    spec.name = "ambience"
    spec.author = "Daniel Harrington"
    spec.email = "me@rubiii.com"
    spec.homepage = "http://github.com/rubiii/ambience"
    spec.summary = "JVM-Parameters for your JRuby app"
    spec.description = spec.summary

    spec.files = FileList["[A-Z]*", "init.rb", "{lib,test}/**/*.{rb,yml}"]

    spec.rdoc_options += [
      "--title", "Ambience",
      "--line-numbers",
      "--inline-source"
    ]
  end
rescue LoadError
  puts "Jeweler missing. Install with: gem install jeweler"
end