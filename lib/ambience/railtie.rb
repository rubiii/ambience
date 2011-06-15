module Ambience
  class Railtie < Rails::Railtie

    initializer 'ambience.railtie', :before => :load_environment_config do |app|
      default_config_file = Rails.root.join("config", "ambience.yml")

      if File.exist?(default_config_file)
        ::AppConfig = Ambience.create(default_config_file, Rails.env).to_mash
      end
    end

  end
end
