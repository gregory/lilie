require './boot.rb'
Bundler.require(:standalone)

require 'grape'
require 'grape-swagger'
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
require 'representers/gallery_representer'
require 'representers/albums_representer'
require 'representers/image_representer'
require 'representers/images_representer'
require 'representers/image_variants_representer'
require 'representers/image_detail_representer'


DataMapper.finalize
class LilieAPI < Grape::API
  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  mount AlbumEndpoint => '/albums'

  add_swagger_documentation \
    mount_path: '/doc',
    base_path: '/doc',
    root_base_path: false,
    hide_documentation_path: true,
    description: {
      desc: "Lilie akka THE gorgeous Image as a Service from BigCommerce"
    }
end

