class DeletePicturesWorker
  def initialize(options={})
    options         = default_options.merge(options)
    @bucket         = options.fetch(:bucket)
    @file_blacklist = options.fetch(:file_blacklist)
    @fog            = Fog::Storage.new(options)
  end

  def run
    files = fog.directories.get(h[:bucket]).files.select{ |file| !file.key.match(%r{\A.*\.html\z}) }.map(&:key)
    fog.delete_multiple_objects(bucket, files) unless files.empty?
  end

  def default_options
    {
      provider:              'AWS',
      bucket:                Dragonfly.app(:lilie).datastore.bucket_name,
      aws_access_key_id:     Dragonfly.app(:lilie).datastore.access_key_id,
      aws_secret_access_key: Dragonfly.app(:lilie).datastore.secret_access_key,
      file_blacklist:        default_file_blacklist
    }
  end

  def default_file_blacklist
    %r{\A.*\.html\z}
  end
end
