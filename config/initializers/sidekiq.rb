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

# config sidekiq cron
schedule_file = "config/schedule.yml"
if File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
else
  raise 'can not find config/schedule.yml file'
end

