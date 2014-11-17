require './lilie_api.rb'
require 'rack/cors'
require 'rack/cache'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

if !RACK_ENV.production?
  use Rack::Cache,
    :verbose     => true,
    :metastore   => 'file:tmp/cache/rack/meta',
    :entitystore => 'file:tmp/cache/rack/body'
else
  use Rack::Cache,
    verbose: true,
    metastore: CACHE,
    entitystore: CACHE
end

use Rack::ConditionalGet
use Rack::ETag
use Dragonfly::Middleware, :lilie
run LilieAPI
