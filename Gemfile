source "http://rubygems.org"

ruby '2.0.0'

gem 'puma'
gem 'dragonfly', '~> 1.0.7'
gem 'dragonfly-s3_data_store'
#gem 'dragonfly-s3_data_store', path: '../dragonfly-s3_data_store/'


group :standalone do
  gem 'grape', '~> 0.9.0'
  gem 'grape-roar'
  gem 'kaminari', '~> 0.14.x', require: 'kaminari/grape'
  gem 'grape-swagger', '~> 0.6.0'
  gem 'activemodel'
  gem 'rack-cors', '~> 0.2.8'
  gem 'data_mapper'
  gem 'roar'
  gem 'hashie'
  gem 'mime-types'
end

group :production do
  gem 'dm-mysql-adapter'
end

group :debug do
  gem 'pry' ,'~> 0.10.1'
  gem 'rerun'
end

group :development do
  gem 'dotenv'
  gem 'dm-sqlite-adapter'
  gem "shoulda", ">= 0"
  gem "rdoc", "~> 3.12"
  gem "bundler", "~> 1.0"
  gem "jeweler", "~> 2.0.1"
  gem "simplecov", ">= 0"
end
