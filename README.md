Ambience [![Build Status](http://travis-ci.org/rubiii/ambience.png)](http://travis-ci.org/rubiii/ambience)
========

App configuration feat. YAML and JVM properties. Lets you specify a default configuration in a YAML  
file and overwrite details via local settings and JVM properties for production.


Installation
------------

Ambience is available through [Rubygems](http://rubygems.org/gems/ambience) and can be installed via:

```
$ gem install ambience
```


Getting started
---------------

Ambience expects your configuration to live inside a YAML file:

``` yml
auth:
  address: http://example.com
  username: ferris
  password: test
```

You can create a new Ambience config by passing in the path to your config file:

``` ruby
AppConfig = Ambience.create Rails.root.join("config", "ambience.yml")
```

Ambience loads your config and converts it into a Hash:

``` ruby
{ "auth" => { "address" => "http://example.com", "username" => "ferris", "password" => "test" } }
```

Afterwards it tries to merge these settings with app-specific setting stored in a file which path is
provided through the AMBIENCE_CONFIG environment variable. Also, if you're using JRuby, Ambience will
merge all JVM properties with the config Hash:

``` ruby
auth.address = "http://live.example.com"
auth.password = "topsecret"
```

The result would be something like this:

``` ruby
{ "auth" => { "address" => "http://live.example.com", "username" => "ferris", "password" => "topsecret" } }
```

You can get the final config as a Hash:

``` ruby
AppConfig = Ambience.create(Rails.root.join("config", "ambience.yml")).to_hash
```

or a [Hashie::Mash](http://github.com/intridea/hashie):

``` ruby
AppConfig = Ambience.create(Rails.root.join("config", "ambience.yml")).to_mash
```


Railtie
-------

Ambience comes with a Railtie which looks for `config/ambience.yml` inside your Rails project.  
If the file exists, Ambience loads the config and stores it in an `AppConfig` constant.  
All this happens before Rails evaluates your environment config.
