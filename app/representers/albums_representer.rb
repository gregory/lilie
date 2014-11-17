require 'representers/paginated_representer'
module AlbumsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include Grape::Roar::Representer
  include PaginatedRepresenter

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/albums"
  end

  collection :to_a, as: :albums do
    include Roar::Representer::JSON::HAL
    property :slug

    link :self do |opts|
      request = Grape::Request.new(opts[:env])
      "#{request.base_url}/albums/#{slug}"
    end
  end
end
