require 'endpoints/image_endpoint'
class AlbumEndpoint < BaseEndpoint
  helpers Garner::Mixins::Rack

  format :json
  formatter :json, Grape::Formatter::Roar

  desc "Info about the albums"
  if RACK_ENV.development?
    desc "List all the albums (development only)"
    params do
      optional :page, type: Integer, default: 1, desc: 'Number of splines to return.'
      optional :size, type: Integer, default: 3, desc: 'Number of splines to return.'
    end
    get '/' do
      present Kaminari.paginate_array(AlbumData.all).page(params[:page]).per(params[:size]), with: AlbumsRepresenter
    end
  end

  desc "Create a new album - TODO: remember the album_id in the session" do
    detail 'more details'
    names 'Albums'
  end
  post '/' do
    album = AlbumData.create
    params[:files].values.each do |file|
      album.images << ImageData.new.tap do |f|
        f.file = file[:tempfile]
        f.file.name = file[:filename]
      end
    end
    album.save
    present album, with: AlbumRepresenter
  end

  #route_param :album_id, requirements: /\^(?!doc)\w*\$/ do
  route_param :album_id, requirements: %r{\w{8}} do
    before do
      @album = AlbumData.first(slug: params[:album_id])
      error!('400 Invalid Album, dude', 400) unless @album
    end

    desc "Push an image to an existing or album"
    post '/' do
      params[:files].values.each do |file|
        @album.images << ImageData.new.tap do |f|
          f.file = file[:tempfile]
          f.file.name = file[:filename]
        end
      end
      @album.save
      present @album, with: AlbumRepresenter
    end

    before do
      header 'Expires' => Time.at(0).utc.to_s
      header 'Cache-Control' => 'public, max-age=31536000'
    end

    helpers do
      def render_html_album
        content_type "text/html"
        "TODO: USE ERB"
      end

      def render_json_album
        present @album, with: AlbumRepresenter
      end
    end

    # TODO: display html page if content type is not json
    desc "List all the images of an album"
    get '/' do
      params[:format] == 'json' ? render_json_album : render_html_album
    end

    mount ImageEndpoint => '/albums'
  end
end
