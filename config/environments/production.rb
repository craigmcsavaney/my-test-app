Myapplication::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  # config.assets.compress = true <- remove the Rails 3 setting
  # config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # added following to try and get heroku asset pipeline working after 4.0 upgrade
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( holder.js select2.js select2.min.js select2_locale_en.js widget/cbwidget.js widget/bootstrap.min.js widget/select2.js widget/select2.min.js widget/select2_locale_en.js widget/cbw-bootstrap.css widget/select2.css widget/cbwidget.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # added by craig as part of rails 4.0 upgrade:
  config.eager_load = true

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.default_url_options = { :host => 'app.causebutton.com' }
  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   address:              'smtp.gmail.com',
  #   port:                 '587',
  #   domain:               'causebutton.com',
  #   user_name:            'craig@causebutton.com',
  #   password:             'USna21412',
  #   authentication:       'plain',
  #   enable_starttls_auto: true  }
  config.action_mailer.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 '587',
    domain:               'heroku.com',
    user_name:            'app16481349@heroku.com',
    password:             'sx4rori8',
    authentication:       'plain',
    enable_starttls_auto: true  }
end
