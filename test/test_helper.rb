require 'rubygems'
require 'test/unit'
require "mocha"
require "shoulda"

require File.join(File.dirname(__FILE__), "fixtures", "fixtures")
require File.join(File.dirname(__FILE__), "..", "lib", "ambience") unless defined? Ambience