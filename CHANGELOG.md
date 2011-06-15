== 1.0.0 (2011-06-15)

  * Cleaned up the project's setup.
  * Moved the config into a module. Instead of calling `Ambience.new`, you can now use
    `Ambience.create` to create the config.
  * Added a Railtie which gets loaded when `Rails` is defined. The Railtie creates an
    `AppConfig` mash from `config/ambience.yml` if such a file exists.
  * Added travis integration: http://travis-ci.org/#!/rubiii/ambience

== 0.3.1 (2010-05-27)

  * Ambience now requires "java" (for JRuby support) if it's available.

== 0.3.0 (2010-05-13)

  * Ambience now operates on the instance level. So after setting up a new Ambience config
    like before:

        AppConfig = Ambience.new File.join(Rails.root, "config", "ambience.yml")

    you now have to choose whether you like to have the config returned as a simple Hash
    or a Hashie::Mash (which was the default since version 0.2.0):

        AppConfig.to_hash
        AppConfig.to_mash

  * Along with support for a basic config and JVM properties, version 0.3.0 adds support
    for local (user-specific) settings. By default, Ambience tries to load a local YAML
    config from:

        File.join ENV["HOME"].to_s, ".ambience", "ambience.yml"

    Ambience will still work fine if the file does not exist. But if you want to use a
    local config and change the default location, you can use the +local_config+ class
    method to do so.

        Ambience.local_config # => "/Users/you/.ambience/ambience.yml"

        # Change the location of the local config file:
        Ambience.local_config = File.join "config", "user_config.yml"

== 0.2.0 (2010-03-06)

  * Complete rewrite. Removed Rails-specific defaults and returning the Ambience config
    as a Hashie::Mash (http://github.com/intridea/hashie). Take a look at the new Readme
    and Specs for examples.

== 0.1.0 (2009-12-12)

  * Initial release.
