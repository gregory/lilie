class AlbumEndpoint < BaseEndpoint
  prefix 'albums'

  post '/' do
    album_data = AlbumData.create
    AlbumRepresenter.new(album_data)
  end

  get '/' do
    albums_data = AlbumData.all
    AlbumsRepresenter.new(albums_data)
  end

  get '/:id' do
    album_data = AlbumData.first(slug: params[:id])
    AlbumRepresenter.new(album_data)
  end
end
