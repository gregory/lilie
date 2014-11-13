require 'grape'

module Lilie
  autoload :BaseEndpoint,  'endpoints/base_endpoint'
  autoload :AlbumEndpoint, 'endpoints/album_endpoint'

  class API < Grape::API
    format :json
    mount AlbumEndpoint => '/'
  end
end
