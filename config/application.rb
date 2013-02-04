require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Babysworld
  class Application < Rails::Application
    config.i18n.default_locale = :zh_tw

    config.encoding = "utf-8"

    config.filter_parameters += [:password]

    config.active_support.escape_html_entities_in_json = true

    config.active_record.whitelist_attributes = true

    config.time_zone = 'Taipei'

    config.assets.enabled = true

    config.assets.version = '1.0'

    config.assets.precompile += %w( admin/*
                                    admin.css
                                    font-awesome/css/*)
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.assets.precompile += %w( .svg .eot .woff .ttf )


    Slim::Engine.set_default_options :pretty => true

    $EMAIL_CONFIG = ActiveSupport::HashWithIndifferentAccess.new YAML.load(File.open("#{Rails.root}/config/email.yml"))[Rails.env]

    config.action_mailer.default_url_options = { :host => $EMAIL_CONFIG[:host] }

    config.action_mailer.smtp_settings = $EMAIL_CONFIG[:smtp].symbolize_keys if !$EMAIL_CONFIG[:smtp].nil?

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

  end
end
