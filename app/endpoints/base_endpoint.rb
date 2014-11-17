class BaseEndpoint < Grape::API
  rescue_from :all do |e|
    error_response({message: 'something horrible happened, please report, dude'})
  end
  rescue_from ArgumentError do |e|
    Rack::Response.new([ "ArgumentError: #{e.message}, dude" ], 500).finish
  end
end
