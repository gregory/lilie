class ImageFilterEndpoint < BaseEndpoint
  format :json
  formatter :json, Grape::Formatter::Roar

  desc "Visualise a transformation"
  get '/filter::filters/:filename' do
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
        f.steps = transformed_image.steps
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
