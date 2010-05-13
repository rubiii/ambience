require "spec_helper"

describe Ambience do
  include SpecHelper

  it "should return the content of a given config file as a Hash" do
    config = Ambience.new(config_file(:basic)).to_hash
    
    config.should be_a(Hash)
    config["auth"]["username"].should == "ferris"
    config["auth"]["password"].should == "test"
  end

  it "should return the content of a given config file as a Hashie::Mash" do
    config = Ambience.new(config_file(:basic)).to_mash
    
    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth][:address].should == "http://example.com"
    config["auth"]["password"].should == "test"
  end

  it "should return the config for an optional environment as a Hashie::Mash" do
    config = Ambience.new(config_file(:environments), :production).to_mash
    
    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth]["password"].should == "topsecret"
  end

  it "should return the config specified as Symbols as a Hashie::Mash" do
    config = Ambience.new(config_file(:symbols), "production").to_mash
    
    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth]["password"].should == "test"
  end

  it "should merge the config with any JVM properties when using JRuby" do
    Ambience.stubs(:jruby?).returns(true)
    Ambience.any_instance.stubs(:jvm_properties).returns(
      "auth.address" => "http://live.example.com",
      "auth.password" => "topsecret"
    )
    config = Ambience.new(config_file(:basic)).to_mash

    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth][:address].should == "http://live.example.com"
    config["auth"]["password"].should == "topsecret"
  end

  it "should raise an ArgumentError in case the given config file could not be found" do
    lambda { Ambience.new("missing_config.yml").to_hash }.should raise_error(ArgumentError)
  end

end
