require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'www.sales-forge.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    user_name: ENV['PROD_USER_NAME'],
    password: ENV['PROD_PASSWORD'],
    domain: 'gmail.com',
    address: 'smtp.gmail.com',
    port: 465,
    enable_starttls_auto: true
  }
  # Store files locally.
  config.active_storage.service = :local

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local = false

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.active_storage.service = :local

  config.log_level = :info

  config.log_tags = [:request_id]

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.serve_static_assets = true
  config.hosts << 'www.sales-forge.com'
  config.hosts << '190.92.179.150'
  config.hosts << 'pos.sales-forge.com'
  config.hosts << 'sales-forge.com'
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :info
  config.logger = Logger.new(STDOUT)
  config.log_tags = %i[request_id user_id]

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
