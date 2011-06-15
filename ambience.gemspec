$:.push File.expand_path("../lib", __FILE__)
require "ambience/version"

Gem::Specification.new do |s|
  s.name        = "ambience"
  s.version     = Ambience::VERSION
  s.author      = "Daniel Harrington"
  s.email       = "me@rubiii.com"
  s.homepage    = "http://github.com/rubiii/#{s.name}"
  s.summary     = %q{App configuration feat. YAML and JVM properties}
  s.description = s.summary

  s.rubyforge_project = s.name

  s.add_dependency "hashie", ">= 0.2.0"

  s.add_development_dependency "rake",     "0.8.7"
  s.add_development_dependency "rspec",    "~> 2.6.0"
  s.add_development_dependency "mocha",    "~> 0.9.12"
  s.add_development_dependency "autotest", "

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
