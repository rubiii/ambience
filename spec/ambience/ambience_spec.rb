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
    expect { Ambience.create("missing_config.yml").to_hash }.to raise_error(ArgumentError)
  end

  context "when using JRuby" do
    before do
      Ambience.stubs(:jruby?).returns(true)
      Ambience::Config.send(:define_method, :java) { JavaMock }
    end

    after do
      Ambience::Config.send(:remove_method, :java)
    end

    it "merges the config with any JVM properties" do
      config = Ambience.create(config_file(:basic)).to_mash

      config.should be_a(Hashie::Mash)
      config.auth.username.should == "ferris"
      config[:auth][:address].should == "http://live.example.com"
      config["auth"]["password"].should == "topsecret"
    end
  end

  context "with an env config file" do
    it "merges the config with the env config" do
      ENV["AMBIENCE_CONFIG"] = config_file(:env_config)
      config = Ambience.create(config_file(:basic)).to_mash

      config.auth.address.should == "http://live.example.com"
    end
  end

  def config_file(name)
    File.expand_path("../../fixtures/#{name}.yml", __FILE__)
  end

end
