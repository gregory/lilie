require 'representers/image_detail_representer'

module AlbumRepresenter
  include Grape::Roar::Representer
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  property :slug
  property :created_at
  property :updated_at
  property :total

  def total
    images.count
  end

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{slug}"
  end

  curies do |opts|
    request = Grape::Request.new(opts[:env])
    [
      {
        name: :images_details,
        href: "#{request.base_url}/#{slug}/images/{uuid}"
      }
    ]
  end

  collection :images, extend: ImageDetailRepresenter,  as: :images
end
