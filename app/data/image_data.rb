require 'securerandom'
require 'dragonfly/model/validations'
require 'active_model/validator'

class ImageData
  def self.before_save(method)
    unless hooks[:save][:before].map{|h| h.instance_variable_get(:@method)}.include?(method)
      before(:save, method)
    end
  end

  def self.before_destroy(method)
    unless hooks[:destroy][:before].map{|h| h.instance_variable_get(:@method)}.include?(method)
      before(:destroy, method)
    end
  end

  extend Dragonfly::Model
  extend Dragonfly::Model::Validations
  include DataMapper::Resource

  storage_names[:default] = 'images'

  SLUG_LENGTH = 8

  dragonfly_accessor :file, app: :lilie do
    after_assign do |file|
    end
    storage_options do |file|
      { path: "#{album.slug}/#{uuid}/#{file.name}" } #/album_id/uuid/version/file.name
    end
  end

  belongs_to :album, 'AlbumData'
  property :id, Serial
  property :album_id, Integer, required: true
  property :uuid, String, required: true, default: ->(resource, prop) { SecureRandom.uuid }
  property :file_uid, String, length: 255
  property :file_aspect_ratio, Float
  property :file_name, String, length: 50
  property :file_shot_at, DateTime
  property :file_fingerprint, String, length: 255
  property :created_at, DateTime
  property :updated_at, DateTime
  property :transformations, Text, lazy: false

  validates_presence_of :file

  def dirty_self?
    dragonfly_attachments.keys.any? { |k| !!send(k) && !send("#{k}_uid")} || super
  end
  def steps=(steps)
    @steps = steps.map do |step|
      "#{step.class.step_name}(#{step.args.map{|a| a.inspect }})"
    end.tap do |s|
      self.transformations = s.join(', ')
    end
  end
end
