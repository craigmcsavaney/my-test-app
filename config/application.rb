require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
  # Newer, simpler method for Rails 4:
  Bundler.require(:default, Rails.env)
end

module Myapplication
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # following added after upgrade to 4.0 to deal with new I18n locale enforcement policy
    # setting to false because we don't currently care about available locales - just
    # using the default locale 
    config.i18n.enforce_available_locales = false

    # following added after upgrade to 4.0 to deal with new header security requirements:
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    config.assets.precompile += %w( glyphicons-halflings.png holder.js select2.js select2.min.js select2_locale_en.js cbwidget.js select2.min.js select2.css cbwidget.css )
    config.secret_key_base = 'f610e803705c6045a6525af28d317b732731f9151d5410be83a063dd6c983e4966ece0975fb26bba8a2f8137d2b102e88d29ab8a947deb128c0bbf9bdaae29d6'
    # config.assets.paths << Rails.root.join('app', 'assets', 'javascripts','widget')
    # config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets','widget')
  end
end
