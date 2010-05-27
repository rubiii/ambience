require "rake"

Gem::Specification.new do |s|
  s.name = "ambience"
  s.version = "0.3.1"
  s.date = "2010-05-27"

  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/rubiii/ambience"
  s.summary = "App configuration feat. YAML and JVM properties"

  s.files = FileList["[A-Z]*", "{lib,spec}/**/*.{rb,yml}"]
  s.test_files = FileList["spec/**/*.rb"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options  = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.rdoc_options += ["--title", "Ambience - App configuration feat. YAML and JVM properties"]

  s.add_dependency "hashie", ">= 0.2.0"

  s.add_development_dependency "rspec", ">= 1.2.8"
  s.add_development_dependency "mocha", ">= 0.9.7"
end
