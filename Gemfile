source 'https://rubygems.org'


#OAuth
gem 'omniauth'
gem 'omniauth-github'


gem 'slim-rails'
gem 'sidekiq'
gem 'sidekiq-cron', '~> 0.3.0'
gem 'sinatra', :require => nil

gem 'rest-client', :require => "restclient"

gem 'font-awesome-rails'

# use git
gem 'git'

#To parse Xml
gem 'nokogiri'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bootstrap_form'

gem "puma", '~> 2.11'
gem "foreman"

gem "figaro", '~> 1.1'

gem 'mailgun_rails', :group => :production
gem "letter_opener", :group => :development

gem 'sass-globbing'

gem 'pry-rails'

gem 'qiniu'

gem 'redcarpet', '>= 3.3.0'

gem 'mixpanel-ruby', require: true

group :production do
  gem 'newrelic_rpm'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development



group :development do
  # for livereload
  # gem 'guard', require: false
  # gem 'guard-livereload', require: false
  # gem 'rb-fsevent', require: false
  # gem 'rack-livereload'

end

group :test do
  # Using Rspec tot test
  # explicit require to help zeus to load rspec. See: https://github.com/burke/zeus/issues/474#issuecomment-89336625
  gem "rspec-rails"# require: "rspec/rails" # including this in environments other than test seems to break things.

  gem "capybara"
  gem "capybara-webkit"


  gem 'rack_session_access'


  # set data to database
  gem 'factory_girl_rails'

  # clean the database
  gem 'database_cleaner'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

   #Speedup Test::Unit + RSpec + Cucumber + Spinach by running parallel on multiple CPU cores.
  gem "parallel_tests"

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'annotate'


  gem 'quiet_assets'

end

