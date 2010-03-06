require "spec"
require "mocha"

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require "ambience"

module SpecHelper

  def config_file(name)
    File.join File.dirname(__FILE__), "fixtures", "#{name}.yml"
  end

end
