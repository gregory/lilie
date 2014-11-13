require './boot.rb'
require './lib/api.rb'

Bundler.require(:standalone)

run Lilie::API
