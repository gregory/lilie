module ImageRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Coercion
  include Grape::Roar::Representer

  property :uuid
  property :file_name, as: :filename
  property :file_fingerprint, as: :fingerprint
  property :file_shot_at, as: :shot_at, type: DateTime
  property :file_aspect_ratio, as: :aspect_ratio
  property :updated_at, type: DateTime
end
