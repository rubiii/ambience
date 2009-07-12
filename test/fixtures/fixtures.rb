module Fixtures

  def some_config_file
    File.join(File.dirname(__FILE__), "some_config.yml")
  end

  def some_config_hash
    { "auth" => { "user" => "test", "password" => "test" } }
  end

  def some_jvm_properties
    { "auth.user" => "jvm" }
  end

  def some_converted_jvm_properties
    { "auth" => { "user" => "jvm" } }
  end

  def some_jvm_updated_config_hash
    { "auth" => { "user" => "jvm", "password" => "test" } }
  end

end