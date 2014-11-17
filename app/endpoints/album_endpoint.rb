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
    album = cookies[:album_id].nil? ? AlbumData.create : AlbumData.first(slug: cookies[:album_id])
    error!('400 Invalid Album, dude', 400) unless album

    params[:files].values.each do |file|
      album.images << ImageData.new.tap do |f|
        f.file = file[:tempfile]
        f.file.name = file[:filename]
      end
    end
    album.save
    cookies[:album_id] = album.slug
    present album, with: AlbumRepresenter
  end

  #route_param :album_id, requirements: /\^(?!doc)\w*\$/ do
  route_param :album_id do
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

    helpers do
      def render_html_album
        require 'erb'
        content_type MIME::Types.type_for(".html")[0].to_s
        env['api.format'] = :binary
        @gallery = @album.images.extend(GalleryRepresenter).to_json(env: env)
        template = ERB.new File.read(File.join(ROOT_PATH, "app", "views", "album.html.erb"))
        template.result(binding)
      end

      def render_json_album
        present @album, with: AlbumRepresenter
      end
    end

    desc "List all the images of an album"
    get '/' do
      params[:format] == 'json' ? render_json_album : render_html_album
    end

    mount ImageEndpoint => '/albums'
  end
end
