require 'forwardable'
module ImageDetailRepresenter
  extend Forwardable
  include Grape::Roar::Representer
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include ImageRepresenter

  def_delegators :file, :width, :height
  property :width
  property :height
  property :album_id

  def album_id
    album.slug
  end

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{album.slug}/images/#{uuid}/#{file.basename}-#{updated_at.to_i}.json"
  end

  link "image:original" do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{album.slug}/images/#{uuid}/#{file.basename}-#{updated_at.to_i}.#{file.ext}"
  end

  link "image:thumb" do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{album.slug}/images/#{uuid}/filter:thumb(100x100)/#{file.basename}-#{updated_at.to_i}.#{file.ext}"
  end
end
