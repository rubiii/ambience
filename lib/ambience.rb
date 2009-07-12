require "rubygems"
require "yaml" unless defined? YAML
require "erb" unless defined? ERB

class Ambience
  class << self

    # Returns a new config Hash for a given Rails +environment+ from a given
    # +config_file+. Adds the current JVM properties to the config Hash in case
    # the application is running on JRuby.
    def new(environment = RAILS_ENV, config_file = nil)
      hash = setup_config environment, load_config_file(config_file)
      hash = setup_jvm hash
    end

    # Returns if the application's running on JRuby.
    def jruby?
      RUBY_PLATFORM =~ /java/
    end

  private

    # Loads the given +config_file+. Tries to load "ambience.yml" from the
    # application's config folder in case no +config_file+ was given. Returns
    # the content from the config file or nil in case no config file was found.
    def load_config_file(config_file)
      config_file ||= File.join(RAILS_ROOT, "config", "ambience.yml")
      config = File.expand_path(config_file)
      file = File.read(config) if File.exist? config
      file ||= nil
    end

    # Returns the ERB-interpreted content at the given +env+ from a given Yaml
    # +config+ String and returns a Hash containing the evaluated content.
    # Defaults to returning an empty Hash in case +config+ is nil.
    def setup_config(env, config)
      hash = YAML.load(ERB.new(config).result)[env] unless config.nil?
      hash ||= {}
    end

    # Expects the current config +hash+, iterates through the JVM properties,
    # adds them to the given +hash+ and returns the merged result.
    def setup_jvm(hash)
      if jruby?
        jvm_properties.each do |key, value|
          param = hash_from_property key, value
          hash = deep_merge(hash, param) unless hash.nil?
        end
      end
      hash
    end

    # Merges a given +hash+ with a +target+ Hash and returns the merged result.
    def deep_merge(hash, target)
      target.keys.each do |key|
        if target[key].is_a? Hash and hash[key].is_a? Hash
          hash[key] = deep_merge(hash[key], target[key])
          next
        end
        hash[key] = target[key]
      end
      hash
    end

    # Expects +key+ and +value+ from a JVM property and returns a Hash that
    # complies to the YAML format.
    def hash_from_property(key, value)
      hash, split = {}, key.split(".")
      (split.size-1).downto(0) do |i|
        v = i == (split.size-1) ? value : hash
        hash = { split[i] => v }
      end
      hash
    end

    # Returns the JVM properties.
    def jvm_properties
      JavaLang::System.get_properties
    end

  end
end

if Ambience.jruby?
  module JavaLang
    include_package "java.lang"
  end
end