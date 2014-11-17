require 'forwardable'
module ImageVariantsRepresenter
  extend Forwardable
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Coercion
  include Grape::Roar::Representer
  include PaginatedRepresenter
  include Roar::Representer::JSON::HAL

  def_delegator :album, :slug, :album_id

  property :uuid
  property :album_id

  def album
    @album ||= to_a[0].album
  end

  def uuid
    @uuid ||= to_a[0].uuid
  end

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/albums/#{album.slug}/images/#{uuid}.json"
  end

  link :variants_album do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/albums/#{album.slug}/images/#{uuid}/"
  end

  collection :to_a, as: :variants  do
    include Roar::Representer::JSON::HAL

    property :file_name, as: :filename
    property :file_aspect_ratio, as: :aspect_ratio
    property :updated_at, type: DateTime
    property :steps, as: :transformations

    link :image do |opts|
      "#{file.remote_url(host: CONFIG.assets_host)}?#{updated_at.to_i}"
    end

    link :self do |opts|
      request = Grape::Request.new(opts[:env])
      "#{request.base_url}/albums/#{album.slug}/images/#{uuid}/#{file.basename}.json"
    end
  end
end
