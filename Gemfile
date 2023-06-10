source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'capistrano-rvm'
gem "bootsnap", require: false
gem 'devise'
gem 'devise-jwt'
gem 'schema_to_scaffold'
gem 'dotenv'
gem 'activestorage'
gem 'devise-async'
gem 'jsonapi-serializer'
gem "image_processing", ">= 1.2"
gem 'rolify'
gem 'kaminari'
gem 'cancancan'
gem "rack-cors"
gem 'kaminari-actionview', require: ['kaminari/core', 'kaminari/actionview']

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'faker'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'capistrano',         require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
end

