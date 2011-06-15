Ambience [![Build Status](http://travis-ci.org/rubiii/ambience.png)](http://travis-ci.org/rubiii/ambience)
========

App configuration feat. YAML and JVM properties. Lets you specify a default configuration in a YAML file
and overwrite details via local settings and JVM properties for production.


Installation
------------

Ambience is available through [Rubygems](http://rubygems.org/gems/ambience) and can be installed via:

```
$ gem install ambience
```


Getting started
---------------

Given you created a YAML config like this:

``` yml
auth:
  address: http://example.com
  username: ferris
  password: test
```

You can instantiate an Ambience config by passing in the path to your config file:

``` ruby
AppConfig = Ambience.create Rails.root.join("config", "ambience.yml")
```

Ambience will load and convert your config into a Hash:

``` ruby
{ "auth" => { "address" => "http://example.com", "username" => "ferris", "password" => "test" } }
```

Afterwards it tries to merge these settings with local ones specified in an Ambience.local_config file.
Finally it looks for any JVM properties (if your running JRuby) and merge these properties with your config:

``` ruby
auth.address = "http://live.example.com"
auth.password = "topsecret"
```

The result would be something like this:

``` ruby
{ "auth" => { "address" => "http://live.example.com", "username" => "ferris", "password" => "topsecret" } }
```

In the end you can decide whether you want to return the config as a Hash:

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
