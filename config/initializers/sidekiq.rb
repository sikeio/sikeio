redis_server = ENV["REDIS_HOST"] || raise("Must set REDIS_HOST")
redis_port = ENV["REDIS_PORT"] || 6379
redis_db_num = ENV["SIDEKIQ_REDIS_DB"] || raise("Must set SIDEKIQ_REDIS_DB")

redis_url = "redis://#{redis_server}:#{redis_port}/#{redis_db_num}"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
