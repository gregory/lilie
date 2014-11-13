require './boot.rb'
require './api.rb'

desc 'API routes the rails way'
task :routes do
  Lilie::API.routes.each do |api|
    #options = api.instance_variable_get('@options')
    method = api.route_method.ljust(10)
    path = api.route_path
    puts "         #{method} #{path}"
  end
end
