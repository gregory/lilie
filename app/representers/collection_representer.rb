class CollectionRepresenter < BaseRepresenter
  include Enumerable

  def initialize(collection)
    @collection = collection
  end

  def each
    if represent_class.present?
      @collection.each { |em| yield(represent_class.new(em)) }
    else
      @collection.each { |em| yield(BaseRepresenter.new(em)) }
    end
  end

  def represent_class
    AlbumRepresenter
  end

  def to_hash(options={})
    map { |em| em.to_hash(options) }
  end
end
