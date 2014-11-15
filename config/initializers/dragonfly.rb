require 'lilie/jobs'
Dragonfly.app(:lilie).configure do |config|
  plugin :imagemagick

  verify_urls true
  secret ENV['DRAGONFLY_SECRET'] || 'changeme'

  if RACK_ENV.development?
    datastore :file, root_path: File.join(ROOT_PATH, 'public/images'), server_root: 'public'
  else
    datastore :s3,
      bucket_name: 'img.gregory.io',
      access_key_id: ENV['AWS_KEY_ID'],
      secret_access_key: ENV['AWS_ACCESS_KEY'],
      url_scheme: 'https'

      #NOTE: Hack to get it working with bucketnames like: foo.bar.com
      #   -> https://github.com/fog/fog/issues/2381#issuecomment-63153626
    Fog.credentials = {:endpoint => 'http://s3-us-west-1.amazonaws.com'}
  end

  url_host CONFIG.assets_host
  url_format "/images/:job/:sha"
end
