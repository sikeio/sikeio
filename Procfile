# sidekiq: bundle exec sidekiq -q mailers -q default
proxy: node proxy/index.js
app: bundle exec puma -C config/puma.rb -p 30001
static: cd static && PORT=30000 make devserver
