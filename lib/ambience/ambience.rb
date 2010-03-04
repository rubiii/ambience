require "yaml" unless defined? YAML
require "erb" unless defined? ERB

# = Ambience
#
# JRuby on Rails app configuration feat. YAML and JVM properties. Lets you specify a default
# configuration in a YAML file and overwrite its properties via JVM properties for production.
class Ambience
  class << self

    # Returns a new config Hash for a given Rails app +environment+ from a given +config_file+.
    # Overwrites properties with any JVM properties (in case the application is running on JRuby).
    def new(config_file = nil, environment = nil)
      hash = parse_config load_config(config_file), environment
      hash = merge_jvm_properties_with hash
    end

    # Returns if the application's running on JRuby.
    def jruby?
      RUBY_PLATFORM =~ /java/
    end

  private

    # Loads the given +config_file+. Tries to load "ambience.yml" from the
    # application's config folder in case no +config_file+ was given. Returns
    # the content from the config file or nil in case no config file was found.
      def load_config(config_file)
      config_file ||= File.join(RAILS_ROOT, "config", "ambience.yml")
      config = File.read config_file if File.exist? config_file
      config || nil
    end

    # Returns the ERB-interpreted content at the given +env+ from a given YAML
    # +config+ String and returns a Hash containing the evaluated content.
    # Defaults to returning an empty Hash in case +config+ is nil.
    def parse_config(config, environment)
      config_hash = YAML.load(ERB.new(config).result)
      config_hash = config_hash[environment] if environment
      config_hash || {}
    end

    # Expects the current config +hash+, iterates through the JVM properties,
    # adds them to the given +hash+ and returns the merged result.
    def merge_jvm_properties_with(hash)
      return hash unless jruby?

      jvm_properties.each do |key, value|
        param = hash_from_property key, value
        hash = deep_merge hash, param if hash
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
