require "rake"
require "spec/rake/spectask"
require "spec/rake/verify_rcov"

task :default => :spec

Spec::Rake::SpecTask.new do |spec|
  spec.spec_files = FileList["spec/**/*_spec.rb"]
  spec.spec_opts << "--color"
  spec.libs += ["lib", "spec"]
  spec.rcov = true
end

RCov::VerifyTask.new(:spec_verify => :spec) do |verify|
  verify.threshold = 100.0
  verify.index_html = "rcov/index.html"
end

begin
  require "hanna/rdoctask"

  Rake::RDocTask.new do |rdoc|
    rdoc.title = "Ambience - App configuration feat. YAML and JVM properties"
    rdoc.rdoc_dir = "doc"
    rdoc.rdoc_files.include("**/*.rdoc").include("lib/**/*.rb")
    rdoc.options << "--line-numbers"
    rdoc.options << "--webcvs=http://github.com/rubiii/ambience/tree/master/"
  end
rescue LoadError
  puts "'gem install hanna' for documentation"
end
