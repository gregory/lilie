Dragonfly.app(:lilie).configure do |config|
  plugin :imagemagick

  verify_urls true
  secret ENV['DRAGONFLY_SECRET'] || 'changeme'
  datastore :file, root_path: File.join(ROOT_PATH, 'public/images'), server_root: 'public'
  #datastore :s3,
    #bucket_name: 'lilie',
    #access_key_id: '',
    #secret_access_key: '',
    #url_scheme: 'https'
  url_host 'http://localhost:5000/'
  url_path_prefix '/assets'
end
