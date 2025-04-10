require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Spatify
  class Application < Rails::Application
    config.load_defaults 7.1

    # Setze Standard-Sprache und Zeitzone
    config.i18n.default_locale = :de
    config.time_zone = "Berlin"

    config.action_controller.raise_on_missing_callback_actions = false if Rails.version >= "7.1.0"
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end

    config.autoload_lib(ignore: %w(assets tasks))
  end
end
