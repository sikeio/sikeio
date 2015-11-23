# sidekiq: bundle exec sidekiq -q mailers -q default
proxy: node proxy/index.js
app: bundle exec puma -C config/puma.rb -p 30001
static: cd static && harp server -p 30000
