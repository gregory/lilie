require './lilie_api.rb'
require 'rack/cors'
require 'rack/cache'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

use Rack::Cache,
  verbose: RACK_ENV.development?,
  metastore: CACHE,
  entitystore: CACHE

use Dragonfly::Middleware, :lilie
run LilieAPI
