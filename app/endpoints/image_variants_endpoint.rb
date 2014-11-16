class ImageVariantsEndpoint < BaseEndpoint
  format :json
  formatter :json, Grape::Formatter::Roar

  route_param :album_id do
    before do
      @album = AlbumData.first(slug: params[:album_id])
      error!('400 Invalid Album, dude', 400) unless @album
    end

    resources :images do
      route_param :uuid do
        before do
          @image_variants = @album.images.all(uuid: params[:uuid])
          error!('400 Invalid Image, dude', 400) if @image_variants.empty?
        end

        helpers do
          def render_image_variants
            content_type "text/html"
            "TODO: USE ERB"
          end

          def render_image_variant_details
            present Kaminari.paginate_array(@image_variants).page(params[:page]).per(params[:size]), with: ImageVariantsRepresenter
          end
        end

        desc "Get info about an image variants"
        get '/' do
          params[:format] == 'json' ? render_image_variant_details : render_image_variants
        end
      end
    end
  end
end
