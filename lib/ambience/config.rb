require "yaml" unless defined? YAML
require "erb" unless defined? ERB

require "hashie"
require "ambience/core_ext"

begin
  require "java"
rescue LoadError
end

module Ambience

  # = Ambience::Config
  #
  # App configuration feat. YAML and JVM properties. Lets you specify a default configuration
  # in a YAML file and overwrite details via local settings and JVM properties for production.
  class Config

    class << self

      def env_config
        @env_config ||= "AMBIENCE_CONFIG"
      end

      attr_writer :env_config

    end

    def initialize(base_config, env = nil)
      self.base_config = base_config
      self.env = env
    end

    attr_accessor :base_config, :env

    # Returns the Ambience config as a Hash.
    def to_hash
      config = load_base_config
      config = config.deep_merge(load_env_config)
      config.deep_merge(load_jvm_config)
    end

    # Returns the Ambience config as a Hashie::Mash.
    def to_mash
      Hashie::Mash.new to_hash
    end

  private

    def load_base_config
      load_config base_config
    end

    def load_env_config
      config = ENV[self.class.env_config]
      config ? load_config(config) : {}
    end

    def load_config(config_file)
      raise ArgumentError, "Missing config file: #{config_file}" unless File.exist?(config_file)

      config = File.read config_file
      config = YAML.load ERB.new(config).result || {}
      config = config[env.to_s] || config[env.to_sym] if env
      config
    end

    def load_jvm_config
      jvm_properties.inject({}) do |hash, (key, value)|
        hash.deep_merge hash_from_property(key, value)
      end
    end

    def jvm_properties
      Ambience.jruby? ? java.lang.System.get_properties : {}
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

  end
end
