require './boot.rb'
Bundler.require(:standalone)

require 'grape'

require 'endpoints/base_endpoint'
require 'endpoints/album_endpoint'
require 'data/album_data'

DataMapper.finalize
class LilieAPI < Grape::API
  format :json
  mount AlbumEndpoint => '/'
end
