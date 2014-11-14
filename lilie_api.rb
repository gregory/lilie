require './boot.rb'
Bundler.require(:standalone)

require 'grape'
require 'hashie'

require 'endpoints/base_endpoint'
require 'endpoints/album_endpoint'
require 'data/album_data'

require 'representers/base_representer'
require 'representers/collection_representer'
require 'representers/album_representer'
require 'representers/albums_representer'

DataMapper.finalize

API_CONFIG = Hashie::Mash.load(File.join(ROOT_PATH, 'config', 'api.yml'))[RACK_ENV.env]

class LilieAPI < Grape::API
  format :json
  mount AlbumEndpoint => '/'
end
