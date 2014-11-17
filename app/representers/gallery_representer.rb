module GalleryRepresenter
  include Grape::Roar::Representer
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  collection :to_a, as: :images do |s|
    property :file_aspect_ratio, as: :aspect_ratio
    property :small

    define_method :small do
      "#{CONFIG.api_endpoint}/albums/#{album.slug}/images/#{uuid}/#{file.basename}.#{file.ext}"
    end
  end
end
