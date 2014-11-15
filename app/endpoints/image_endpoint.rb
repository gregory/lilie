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
      get '/:id.json' do
        image_data = @album.images.first(id: params[:id])
        present image_data, with: ImageDetailRepresenter
      end

      desc "Get info about an image"
      get '/:id' do
        image_data = @album.images.first(id: params[:id])
        content_type MIME::Types.type_for(image_data.file_name)[0].to_s
        env['api.format'] = :binary
        #NOTE: this will download the image: header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(image_data.file_name)}"
        image_data.file.data
      end
    end
  end
end
