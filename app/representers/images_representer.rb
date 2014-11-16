module ImagesRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Coercion
  include Grape::Roar::Representer

  collection :to_a, as: :images do
    include Roar::Representer::JSON::HAL

    property :uuid
    property :file_name, as: :filename
    property :file_fingerprint, as: :fingerprint
    property :file_shot_at, as: :shot_at, type: DateTime
    property :file_aspect_ratio, as: :aspect_ratio
    property :updated_at, type: DateTime

    link :self do |opts|
      request = Grape::Request.new(opts[:env])
      "#{request.base_url}/#{album.slug}/images/#{uuid}/#{file.basename}-#{updated_at.to_i}.#{file.ext}"
    end
  end
end
