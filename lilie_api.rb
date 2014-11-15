require './boot.rb'
Bundler.require(:standalone)

require 'grape'
require "garner/mixins/rack"
require 'roar/representer'
require 'roar/representer/json'
require 'roar/representer/json/hal'
require 'roar/representer/feature/hypermedia'
require 'roar/representer/feature/coercion'

require 'lilie'

require 'endpoints/base_endpoint'
require 'endpoints/album_endpoint'
require 'endpoints/image_endpoint'

require 'data/album_data'
require 'data/image_data'

require 'representers/paginated_representer'
require 'representers/album_representer'
require 'representers/albums_representer'
require 'representers/image_representer'
require 'representers/image_detail_representer'


DataMapper.finalize

class LilieAPI < Grape::API
  mount AlbumEndpoint => '/'
  mount ImageEndpoint => '/'
end
