redis_server = '127.0.0.1' # redis服务器
redis_port = 6379 # redis端口
redis_db_num = 12 # redis 数据库序号

Sidekiq.configure_server do |config|
  p redis_server
  config.redis = { url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}"}
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}" }
end
