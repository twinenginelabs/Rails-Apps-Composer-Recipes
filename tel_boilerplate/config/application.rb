require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module ProjectName
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    def self.name
      "Project Name"
    end

    require "#{config.root}/lib/possessive"

    config.paths["config/routes.rb"].concat Dir[Rails.root.join("config/routes/*.rb")]
    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = 'Central Time (US & Canada)'
    config.filter_parameters += [:password]

    config.generators do |g|
      g.integration_tool false
      g.performance_tool false
      g.helper false
      g.test_framework :rspec,
        view_specs: false,
        routing_specs: false
    end
  end
end
