module ImageRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Coercion
  include Roar::Representer::JSON::HAL
  include Grape::Roar::Representer

  property :uuid
  property :file_name, as: :filename
  property :file_fingerprint, as: :fingerprint
  property :file_shot_at, as: :shot_at, type: DateTime
  property :file_aspect_ratio, as: :aspect_ratio
  property :updated_at, type: DateTime
  property :steps

  def album_slug
    @album_slug ||= album.slug
  end

  link :self do |opts|
    "#{file.remote_url(host: CONFIG.assets_host)}?#{updated_at.to_i}"
  end
end
