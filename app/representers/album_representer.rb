require 'representers/image_representer'

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
    "#{request.base_url}/albums/#{slug}"
  end

  curies do |opts|
    request = Grape::Request.new(opts[:env])
    [
      {
        method: 'GET',
        name: :variants_album,
        href: "#{request.base_url}/albums/#{slug}/images/{uuid}"
      },
      {
        method: 'GET',
        name: :variants,
        href: "#{request.base_url}/albums/#{slug}/images/{uuid}.json"
      },
      {
        method: 'GET',
        name: :image,
        href: "#{request.base_url}/albums/#{slug}/images/{uuid}/{filename}"
      },
      {
        method: 'GET',
        name: :image_details,
        href: "#{request.base_url}/albums/#{slug}/images/{uuid}/{filename}.json"
      },
      {
        method: 'GET',
        name: :filter_image,
        href: "#{request.base_url}/albums/#{slug}/images/{uuid}/filter:[filter1(options),...]/{filename}.json"
      },
      {
        method: 'POST',
        name: :save_filtered_image,
        href: "#{request.base_url}/albums/#{slug}/images/{uuid}/filter:[filter1(options),...]/{filename}.json"
      }
    ]
  end

  collection :images, extend: ImageRepresenter,  as: :images, embedded: true
end
