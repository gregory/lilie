require 'endpoints/image_filter_endpoint'
class ImageEndpoint < BaseEndpoint
  format :json
  formatter :json, Grape::Formatter::Roar

  desc "Image Endpoint"
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
        def render_image
          content_type MIME::Types.type_for(@image_data.file_name)[0].to_s
          env['api.format'] = :binary
          #NOTE: this will download the image: header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(image_data.file_name)}"
          @image_data.file.data
        end

        def render_image_details
          present @image_data, with: ImageDetailRepresenter
        end
        def render_image_variant_details
          present Kaminari.paginate_array(@image_variants).page(params[:page]).per(params[:size]), with: ImageVariantsRepresenter
        end
      end
      desc "Get info about an image variants"
      get '/' do
        params[:format] == 'json' ? render_image_variant_details : render_image_variants
      end

      desc "Get the image"
      get '/:filename' do
        #_, basename = *params[:filename].match(%r{\A(\w*)(?:-(\d*))?\z})
        basename = params[:filename]
        @image_data  = @image_variants.detect{|image| image.file.basename == basename} #TODO: filter by version too
        error!('400 Invalid Image, dude', 400) unless @image_data

        params[:format] == 'json' ? render_image_details : render_image
      end
      mount ImageFilterEndpoint => '/albums'
    end
  end
end
