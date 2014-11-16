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

          Struct.new('Filter', :string, :name, :args)
          filters = params[:filters].split(',').map{|string| Struct::Filter.new *string.match(%r{(.*)\((.*)\)})}.sort{ |f1,f2| f1.name <=> f2.name}

          valid_processor_keys = Dragonfly.app(:lilie).processors.items.keys.map(&:to_s)

          invalids = filters.each_with_object([]) do |filter, array|
            array.push(filter.string) unless valid_processor_keys.include? filter.name
          end
          error!("400 Invalid filters: #{invalids.join(', ')} - valids are: #{valid_processor_keys.join(',')}- (dude)", 400) unless invalids.empty?


          transformed_image = image_data.file
          filters.each { |filter | transformed_image = transformed_image.send(filter.name.to_sym, filter.args) }

          env['api.format'] = :binary
          content_type MIME::Types.type_for(transformed_image.name)[0].to_s
          #NOTE: this will download the image: header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(image_data.file_name)}"
          transformed_image.data
        end

        desc "Store the image in the album"
        post '/filter::filters/:filename-:version' do
          binding.pry
        end
      end
    end
  end
end
