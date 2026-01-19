# config/environments/production.rb

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.log_level = :info
  config.log_tags = [:request_id]

  config.cache_store = :redis_cache_store,
    { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV.fetch("RAILS_HOST") { "localhost" } }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS", "smtp.gmail.com"),
    port: ENV.fetch("SMTP_PORT", 587),
    user_name: ENV.fetch("SMTP_USERNAME"),
    password: ENV.fetch("SMTP_PASSWORD"),
    authentication: :plain,
    enable_starttls_auto: true
  }

  # ActionCable configuration
  config.action_cable.url = ENV.fetch("ACTION_CABLE_URL", "wss://example.com/cable")
  config.action_cable.allowed_request_origins = [ENV.fetch("RAILS_HOST")]

  # Solid Queue configuration
  config.solid_queue.mode = :inline # or :async with separate worker process

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.compile = false
  config.force_ssl = true if ENV["RAILS_ENV"] == "production"
  config.assume_ssl = true
  config.ssl_options = { redirect: { status: 308, body: nil } }
end
