# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'active_storage_validations', '0.8.9'
gem 'bcrypt',         '3.1.13'
gem 'bootsnap',       '1.4.6', require: false
gem 'bootstrap-sass', '3.4.1'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'devise',         '4.7.2'
gem 'devise-jwt', '~> 0.7.0'
gem 'faker',          '2.13.0'
gem 'image_processing', '1.11.0'
gem 'jbuilder',       '2.10.0'
gem 'kaminari',       '1.2.1'
gem 'mini_magick', '4.10.1'
gem 'pg', '1.2.3'
gem 'puma', '4.3.5'
gem 'rack-cors', '1.1.1'
gem 'rails', '6.0.3.2'
gem 'redis'
gem 'sass-rails',     '6.0.0'
gem 'sidekiq',        '6.1.0'
gem 'turbolinks',     '5.2.1'
gem 'webpacker',      '5.1.1'
gem 'will_paginate', '3.3.0'

group :development, :test do
  gem 'byebug', '11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '2.7.5'
  gem 'rubocop'
  gem 'solargraph'
end

group :development do
  gem 'listen',                '3.2.1'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console',           '4.0.3'
end

group :test do
  gem 'capybara',                 '3.33.0'
  gem 'guard',                    '2.16.2'
  gem 'guard-minitest',           '2.4.6'
  gem 'minitest',                 '5.14.1'
  gem 'minitest-reporters',       '1.4.2'
  gem 'rails-controller-testing', '1.0.5'
  gem 'selenium-webdriver',       '3.142.7'
  gem 'webdrivers',               '4.4.1'
  gem 'webmock'
end

group :production do
  gem 'aws-sdk-s3', '1.72.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
