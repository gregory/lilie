class ImageEndpoint < BaseEndpoint
  format :json
  formatter :json, Grape::Formatter::Roar

  route_param :album_id do
    before do
      @album = AlbumData.first(slug: params[:album_id])
      error!('400 Invalid Album, dude', 400) unless @album

      if params[:uuid]
        @image = @album.images.first(uuid: params[:uuid])
        error!('400 Invalid Image, dude', 400) unless @image
      end
    end
    helpers do
      def render_mime_typed_image
        content_type MIME::Types.type_for(@image.file_name)[0].to_s
        env['api.format'] = :binary
        #NOTE: this will download the image: header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(image_data.file_name)}"
        @image.file.data
      end

      def render_json_image
        present @image, with: ImageDetailRepresenter
      end
    end

    resources :images do
      desc "Get info about an image"
      desc "Get info about an image"
      get '/:uuid' do
        params[:format] == 'json' ? render_json_image : render_mime_typed_image
      end
    end
  end
end
