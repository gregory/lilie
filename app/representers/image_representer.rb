module ImageRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Coercion
  include Grape::Roar::Representer

  property :id
  property :created_at, type: DateTime
  property :updated_at

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}/images/#{id}"
  end
end
