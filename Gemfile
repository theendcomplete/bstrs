# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '2.5.1'
gem 'activeadmin'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'rails_admin', '~> 1.4'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# gem 'bootstrap'
gem 'devise'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
# gem 'webpacker', '~> 3.5'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
gem 'bootstrap', '4.1.1'
gem 'bootstrap_form'
gem 'capistrano', '~> 3.7', '>= 3.7.1'
gem 'capistrano-passenger', '~> 0.2.0'
gem 'capistrano-rails', '~> 1.2'
gem 'capistrano-rbenv', '~> 2.1'
# gem 'material-sass', '4.1.1'
gem 'awesome_print'
gem 'pundit'
gem 'simple_form'
gem 'mini_magick'
gem 'rmagick'
gem 'sprockets-rails', require: 'sprockets/railtie'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
## Gemfile for Rails 3+, Sinatra, and Merb
gem 'will_paginate', '~> 3.1.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'mail_form'
gem "font-awesome-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
group :production do
  gem 'pg'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
