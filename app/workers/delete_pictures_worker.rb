requrie 'fog'
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
      bucket:                ENV['AWS_BUCKET_NAME'],
      aws_access_key_id:     ENV['AWS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_ACCESS_KEY'],
      file_blacklist:        default_file_blacklist
    }
  end

  def default_file_blacklist
    %r{\A.*\.html\z}
  end
end
