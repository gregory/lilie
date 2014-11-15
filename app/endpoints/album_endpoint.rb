class AlbumEndpoint < BaseEndpoint
  helpers Garner::Mixins::Rack
  use Rack::ConditionalGet
  use Rack::ETag

  format :json
  formatter :json, Grape::Formatter::Roar

  desc "Create a new album"
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

  # TODO: display html page if content type is not json
  desc "List all the images of an album"
  before do
    header 'Expires' => Time.at(0).utc.to_s
    header 'Cache-Control' => 'public, max-age=31536000'
  end
  get '/:album_id.json' do
    @album = AlbumData.first(slug: params[:album_id])
    error!('400 Invalid Album', 400) unless @album
    #garner  do
      present @album, with: AlbumRepresenter
    #end
  end

  desc "List all the images of an album"
  get '/:album_id' do
    content_type "text/html"
    @album = AlbumData.first(slug: params[:album_id])
    error!('400 Invalid Album', 400) unless @album
    "TODO: USE ERB"
  end

  desc "Push an image to an existing or album"
  post '/:album_id.json' do
    @album = AlbumData.first(slug: params[:album_id])
    error!('400 Invalid Album', 400) unless @album

    params[:files].values.each do |file|
      @album.images << ImageData.new.tap do |f|
        f.file = file[:tempfile]
        f.file.name = file[:filename]
      end
    end
    @album.save
    present @album, with: AlbumRepresenter
  end
end
