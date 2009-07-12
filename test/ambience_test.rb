require File.join(File.dirname(__FILE__), "test_helper")

class AmbienceTest < Test::Unit::TestCase

  include Fixtures

  context "Ambience using anything else than JRuby" do
    setup do
      Ambience.stubs(:jruby?).returns(false)
    end

    context "with config file set up" do
      should "return a Hash containing the config file content" do
        result = Ambience.new "test", some_config_file
        assert_equal some_config_hash, result
      end
    end

    context "with no config file available" do
      should "return an empty Hash" do
        result = Ambience.new "test", "nofile"
        assert_equal Hash.new, result
      end
    end
  end

  context "Ambience using JRuby" do
    setup do
      Ambience.stubs(:jruby?).returns(true)
      Ambience.stubs(:jvm_properties).returns(some_jvm_properties)
    end

    context "with config file set up" do
      should "return a Hash containing the config file and JVM properties" do
        result = Ambience.new "test", some_config_file
        assert_equal some_jvm_updated_config_hash, result
      end
    end

    context "with no config file available" do
      should "return a Hash containing the JVM properties" do
        result = Ambience.new "test", "nofile"
        assert_equal some_converted_jvm_properties, result
      end
    end
  end

end
