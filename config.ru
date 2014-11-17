require './lilie_api.rb'
require 'rack/cors'
require 'rack/cache'

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

SprocketsApp = Sprockets::Environment.new
SprocketsApp.append_path "app/javascripts"

ApplicationServer = Rack::Builder.new {
  #if ['production', 'staging'].include? Application.config.env
    #use Rack::SslEnforcer
  #end

  use Dragonfly::Middleware, :lilie

  use Rack::Static, :urls => [
    "/css",
    "/images",
    "/lib",
    "/swagger-ui.js",
    "/doc.html"
  ], :root => "public", index: 'index.html'

  map "/javascripts" do
    run SprocketsApp
  end

  map "/" do
    run LilieAPI
  end
}

run ApplicationServer
