# config/environments/development.rb

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :letter_opener

  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  
  # ActionCable configuration
  config.action_cable.disable_request_forgery_protection = true
  config.action_cable.url = "ws://localhost:3000/cable"
  config.action_cable.allowed_request_origins = [/http:\/\/localhost:*/, /http:\/\/127.0.0.1:*/]

  config.assets.debug = true
  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
