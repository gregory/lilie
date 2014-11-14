require 'roar/decorator'
require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'
class BaseRepresenter < Roar::Decorator
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  def to_hash(options={})
    super default_options.merge(options)
  end

  def default_options
    {
      api_endpoint: API_CONFIG.api_endpoint
    }
  end

  def represent_class; end
end
