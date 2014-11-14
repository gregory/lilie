class AlbumData
  SLUG_LENGTH = 8
  include DataMapper::Resource

  storage_names[:default] = 'albums'

  has n, :images, 'ImageData', child_key: [:album_id]

  property :id, Serial
  property :slug, String, required: true, unique_index: true,  default: ->(resource, prop) { Array.new(SLUG_LENGTH) { rand(36).to_s(36) }.join }
  property :created_at, DateTime
  property :updated_at, DateTime
end
