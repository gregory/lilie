class ImageEndpoint < BaseEndpoint
  format :json
  formatter :json, Grape::Formatter::Roar

  route_param :album_id do
    before do
      @album = AlbumData.first(slug: params[:album_id])
      error!('400 Invalid Album', 400) unless @album
    end
    resources :images do
      desc "Get info about an image"
      get '/:id' do
        image_data = @album.images.first(id: params[:id])
        #content_type MIME::Types.type_for(filename)[0].to_s
        #env['api.format'] = :binary
        #header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(filename)}"
        #image_data.read
        present image_data, with: ImageDetailRepresenter
      end
    end
  end
end
