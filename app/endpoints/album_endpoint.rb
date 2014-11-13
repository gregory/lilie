class AlbumEndpoint < BaseEndpoint
  prefix 'album'

  post '/' do
    {foo: 'bar'}
  end
end
