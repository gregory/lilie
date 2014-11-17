require 'forwardable'
module ImageDetailRepresenter
  extend Forwardable
  include Grape::Roar::Representer
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include ImageRepresenter

  def_delegators :file, :width, :height
  def_delegator :album, :slug, :album_id

  property :width
  property :height
  property :album_id
  property :steps

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/albums/#{album.slug}/images/#{uuid}/#{file.basename}.json"
  end

  link "image" do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/albums/#{album.slug}/images/#{uuid}/#{file.basename}.#{file.ext}"
  end

  link "image:thumb" do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/albums/#{album.slug}/images/#{uuid}/filter:thumb(100x100%23)/#{file.basename}.#{file.ext}"
  end
end
