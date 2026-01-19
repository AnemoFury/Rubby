Rails.application.configure do
  config.solid_queue.mode = :async
  config.solid_queue.database_url = ENV["DATABASE_URL"]
end
