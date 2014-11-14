require 'forwardable'
module ImageDetailRepresenter
  extend Forwardable
  include Grape::Roar::Representer
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  def_delegator :file, :width
  property :id
  property :width
  property :album_id

  def album_id
    album.slug
  end

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{album_id}/images/#{id}"
  end

  link "image:original" do |opts|
    "#{file.url}"
  end

end
