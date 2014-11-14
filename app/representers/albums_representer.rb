require 'representers/paginated_representer'
module AlbumsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include Grape::Roar::Representer
  include PaginatedRepresenter

  property :count, as: :total

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/"
  end

  collection :to_a, as: :albums do
    include Roar::Representer::JSON::HAL
    property :slug

    link :self do |opts|
      request = Grape::Request.new(opts[:env])
      "#{request.base_url}/#{slug}"
    end
  end
end
