source "http://rubygems.org"

ruby '2.0.0'

gem 'puma'

group :standalone do
  gem 'grape', '~> 0.9.0'
  gem 'data_mapper'
  gem 'roar'
  gem 'hashie'
end

group :production do
  gem 'dm-mysql-adapter'
end

group :development do
  gem 'dm-sqlite-adapter'
  gem 'rerun'
  gem 'pry' ,'~> 0.10.1'
  gem "shoulda", ">= 0"
  gem "rdoc", "~> 3.12"
  gem "bundler", "~> 1.0"
  gem "jeweler", "~> 2.0.1"
  gem "simplecov", ">= 0"
end
