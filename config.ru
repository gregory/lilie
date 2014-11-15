require './lilie_api.rb'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

use Dragonfly::Middleware, :lilie
run LilieAPI
