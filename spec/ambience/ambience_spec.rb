require "spec_helper"

describe Ambience do

  it "returns the content of a given config file as a Hash" do
    config = Ambience.create(config_file(:basic)).to_hash

    config.should be_a(Hash)
    config["auth"]["username"].should == "ferris"
    config["auth"]["password"].should == "test"
  end

  it "returns the content of a given config file as a Hashie::Mash" do
    config = Ambience.create(config_file(:basic)).to_mash

    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth][:address].should == "http://example.com"
    config["auth"]["password"].should == "test"
  end

  it "returns the config for an optional environment as a Hashie::Mash" do
    config = Ambience.create(config_file(:environments), :production).to_mash

    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth]["password"].should == "topsecret"
  end

  it "returns the config specified as Symbols as a Hashie::Mash" do
    config = Ambience.create(config_file(:symbols), "production").to_mash

    config.should be_a(Hashie::Mash)
    config.auth.username.should == "ferris"
    config[:auth]["password"].should == "test"
  end

  it "raises an ArgumentError when the given config file could not be found" do
    lambda { Ambience.create("missing_config.yml").to_hash }.should raise_error(ArgumentError)
  end

  context "when using JRuby" do
    before do
      Ambience::Config.send(:define_method, :java) { JavaMock }
    end

    after do
      Ambience::Config.send(:remove_method, :java)
    end

    it "merges the config with any JVM properties" do
      Ambience.stubs(:jruby?).returns(true)
      Ambience::Config.any_instance.stubs(:jvm_properties).returns(
        "auth.address" => "http://live.example.com",
        "auth.password" => "topsecret"
      )
      config = Ambience.create(config_file(:basic)).to_mash

      config.should be_a(Hashie::Mash)
      config.auth.username.should == "ferris"
      config[:auth][:address].should == "http://live.example.com"
      config["auth"]["password"].should == "topsecret"
    end
  end

  def config_file(name)
    File.expand_path("../../fixtures/#{name}.yml", __FILE__)
  end

end
