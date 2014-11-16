class ImageFilterEndpoint < BaseEndpoint
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

        desc "Visualise a transformation"
        get '/filter::filters/:filename-:version' do
          image_data             = @image_variants.detect{|image| image.file.basename == params[:filename]} #TODO: filter by version too
          error!('400 Invalid Image, dude', 400) unless image_data

          errors, transformed_image = Lilie.transform(image_data.file, params[:filters])
          error!("400 Invalid filters: #{errors}") if errors

          env['api.format'] = :binary
          content_type MIME::Types.type_for(transformed_image.name)[0].to_s
          #NOTE: this will download the image: header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(image_data.file_name)}"
          transformed_image.data
        end

        desc "Store the image in the album"
        post '/filter::filters/:filename' do
          _, basename = *params[:filename].match(%r{(.*)-\d*$})
          image_data = @image_variants.detect{|image| image.file.basename == basename} #TODO: filter by version too
          error!('400 Invalid Image, dude', 400) unless image_data

          errors, transformed_image = Lilie.transform(image_data.file, params[:filters])
          error!("400 Invalid filters: #{errors}") if errors

          target_image = @image_variants.detect{|image| image.file.basename == params[:basename]}
          if target_image # we are updating the image
            target_image.tap do |f|
              basename = f.file.basename
              f.file = transformed_image
              f.file.basename = basename
            end
            target_image.save
          else
            @album.images << ImageData.new.tap do |f|
              f.file = transformed_image
              f.file.basename = params[:basename] || transformed_image.basename
              f.uuid = image_data.uuid
            end
            @album.save
          end
          env['api.format'] = :binary
          content_type MIME::Types.type_for(transformed_image.name)[0].to_s
          #NOTE: this will download the image: header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(image_data.file_name)}"
          transformed_image.data
        end
      end
    end
  end
end
