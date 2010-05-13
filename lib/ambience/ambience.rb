# = Ambience
#
# App configuration feat. YAML and JVM properties. Lets you specify a default configuration
# in a YAML file and overwrite details via local settings and JVM properties for production.
class Ambience

  # Sets the path to a local ambience config file.
  def self.local_config=(local_config)
    @@local_config = local_config
  end

  # Returns the path to a local ambience config file for specifying user-specific
  # settings that don't belong into the application config file.
  def self.local_config
    @@local_config ||= File.join ENV["HOME"].to_s, ".ambience", "ambience.yml"
  end  

  # Returns whether the current Ruby platfrom is JRuby.
  def self.jruby?
   RUBY_PLATFORM =~ /java/
  end

  def initialize(config_file, env = nil)
    @config_file, @env = config_file, env
  end

  # Returns the Ambience config as a Hash.
  def to_hash
    config = load_config @config_file
    config = config.deep_merge local_config
    config.deep_merge jvm_config
  end

  # Returns the Ambience config as a Hashie::Mash.
  def to_mash
    Hashie::Mash.new to_hash
  end

private

  def load_config(config_file)
    raise ArgumentError, "Missing config: #{config_file}" unless File.exist? config_file
    
    config = File.read config_file
    config = YAML.load ERB.new(config).result || {}
    config = config[@env.to_s] || config[@env.to_sym] if @env
    config
  end

  # Returns a Hash containing any local settings from the +@@local_config+.
  def local_config
    File.exist?(self.class.local_config) ? load_config(self.class.local_config) : {}
  end

  ## Returns a Hash containing any JVM properties.
  def jvm_config
    jvm_properties.inject({}) do |hash, (key, value)|
      hash.deep_merge hash_from_property(key, value)
    end
  end

  # Returns the JVM properties.
  def jvm_properties
    JavaLang::System.get_properties rescue {}
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
    self.class.jruby? ? JavaLang::System.get_properties : {}
  end

  if jruby?
    module JavaLang
      include_package "java.lang"
    end
  end

end
