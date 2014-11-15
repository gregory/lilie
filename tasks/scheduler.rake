require 'rake'

desc "Pings ME TO STAY ALIVE!!"
task :ping_dyno do
  require "net/http"
  if ENV['PING_URL']
    uri = URI(ENV['PING_URL'])
    Net::HTTP.get_response(uri)
  end
end
