require './boot.rb'
require './api.rb'

Bundler.require(:standalone)

run Lilie::API
