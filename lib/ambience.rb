require "ambience/config"
require "ambience/version"

require "ambience/railtie" if defined? Rails

module Ambience

  def self.create(config_file, env = nil)
    Config.new(config_file, env)
  end

  def self.jruby?
    RUBY_PLATFORM =~ /java/
  end

end
