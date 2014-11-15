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
    "#{request.base_url}/#{album_id}/images/#{uuid}"
  end

  link "image:original" do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/images/#{uuid}"
  end

  #link "image:rotate" do |opts|
    ##file.url('300x300',:gif)
    ##request = Grape::Request.new(opts[:env])
    ##"#{request.base_url}/images/#{uuid}"
  #end

  link "image:sha" do |opts|
    request = Grape::Request.new(opts[:env])
    "#{file.url}"
  end
end
