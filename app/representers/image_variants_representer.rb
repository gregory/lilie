module ImageVariantsRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Coercion
  include Grape::Roar::Representer
  include PaginatedRepresenter
  include Roar::Representer::JSON::HAL


  def album
    @album ||= to_a[0].album
  end

  def uuid
    @uuid ||= to_a[0].uuid
  end

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{album.slug}/images/#{uuid}.json"
  end

  link :image_variants do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/#{album.slug}/images/#{uuid}/"
  end

  curies do |opts|
    request = Grape::Request.new(opts[:env])
    [
      {
        method: 'POST',
        name: :save_filtered_image,
        href: "#{request.base_url}/#{album.slug}/images/#{uuid}/filter:thumb(200x200),rotate(180)/{filename}",
        params: {
          basename: 'Name of the file to save to'
        }
      },
      {
        method: 'GET',
        name: :image_details,
        href: "#{request.base_url}/#{album.slug}/images/#{uuid}/{filename}"
      },
    ]
  end

  collection :to_a, as: :variants do
    include Roar::Representer::JSON::HAL

    property :uuid
    property :file_name, as: :filename
    property :file_fingerprint, as: :fingerprint
    property :file_shot_at, as: :shot_at, type: DateTime
    property :file_aspect_ratio, as: :aspect_ratio
    property :updated_at, type: DateTime
    property :transformations

    define_method :transformations do
      self.file.job.steps.map do |step|
        step.class.step_name
        "#{step.class.step_name}(#{step.args.map{|a| a.inspect }.join(', ')})"
      end
    end
  end
end
