require './boot.rb'
require './lilie_api.rb'

desc 'API routes the rails way'
task :routes do
  LilieAPI.routes.each do |api|
    options = api.instance_variable_get('@options')
    method = api.route_method
    path = api.route_path
    route = "#{method.ljust(10)} #{path.ljust(40)}"
    route << " => #{options[:description]}" if options[:description].present?
    puts route
  end
end
