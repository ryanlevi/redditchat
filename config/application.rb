require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Redditchat
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
    config.force_ssl = true

    # Don't care if the mailer can't send
    config.action_mailer.raise_delivery_errors = true

    # set delivery method to :smtp, :sendmail or :test
    config.action_mailer.delivery_method = :smtp

    # these options are only needed if you choose smtp delivery
    config.action_mailer.smtp_settings = {
        :address        => 'smtp.gmail.com',
        :port           => 587,
        :domain         => 'gmail.com',
        :authentication => 'plain',
        :user_name      => 'domatio.app',
        :password       => 'costanzo',
        :enable_starttls_auto => true
    }
  end
end
