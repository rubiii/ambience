# = Ambience
#
# App configuration feat. YAML and JVM properties. Lets you specify a default configuration
# in a YAML file and overwrite details via JVM properties for production.
#
# == How it works
#
# Given you created a YAML config like this one:
#
#   auth:
#     address: http://example.com
#     username: ferris
#     password: test
#
# You create an Ambience config by passing in the path to your config file:
#
#   AppConfig = Ambience.new File.join(Rails.root, "config", "ambience.yml")
#
# Ambience will load and convert your config into a Hash:
#
#   { "auth" => { "address" => "http://example.com", "username" => "ferris", "password" => "test" } }
#
# Then it looks for any JVM properties (if your running JRuby)
#
#   auth.address = "http://live.example.com"
#   auth.password = "topsecret"
#
# and deep merge them with your Hash:
#
#   { "auth" => { "address" => "http://live.example.com", "username" => "ferris", "password" => "topsecret" } }
#
# Finally, it returns the Hash as a {Hashie::Mash}[http://github.com/intridea/hashie] so you can
# access values by specifying keys as Symbols or Strings or using method-like accessors:
#
#   AppConfig[:auth][:address]
#   # => "http://live.example.com"
#
#   AppConfig["auth"]["username"]
#   # => "http://live.example.com"
#
#   AppConfig.auth.password
#   # => "topsecret"
class Ambience
  class << self

    # Returns a new Ambience config from a given YAML +config_file+ for an optional +env+.
    # Overwrites properties with any JVM properties (in case the application is running on JRuby).
    def new(config_file, env = nil)
      config_hash = parse_config load_config(config_file)
      config_hash = config_hash[env.to_s] || config_hash[env.to_sym] if env
      config_hash.deep_merge! jvm_property_hash
      Hashie::Mash.new config_hash
    end

    # Returns whether the current Ruby platfrom is JRuby.
    def jruby?
      RUBY_PLATFORM =~ /java/
    end

  private

    # Loads a given +config_file+. Raises an ArgumentError in case the config could not be found.
    def load_config(config_file)
      raise ArgumentError, "Missing config: #{config_file}" unless File.exist? config_file
      File.read config_file
    end

    # Returns the ERB-interpreted content from a given YAML +config+ String and returns a Hash
    # containing the evaluated content. Defaults to returning an empty Hash.
    def parse_config(config)
      YAML.load ERB.new(config).result || {}
    end

    # Returns a Hash containing any JVM properties.
    def jvm_property_hash
      jvm_properties.inject({}) do |hash, (key, value)|
        hash.deep_merge hash_from_property(key, value)
      end
    end

    # Returns a Hash generated from a JVM +property+ and its +value+.
    #
    # ==== Example:
    #
    #   hash_from_property "webservice.auth.address", "http://auth.example.com"
    #   # => { "webservice" => { "auth" => { "address" => "http://auth.example.com" } } }
    def hash_from_property(property, value)
      property.split(".").reverse.inject(value) { |value, item| { item => value } }
    end

    # Returns the JVM properties.
    def jvm_properties
      jruby? ? JavaLang::System.get_properties : {}
    end

  end

  if jruby?
    module JavaLang
      include_package "java.lang"
    end
  end

end
