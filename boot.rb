require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'data_mapper'

ROOT_PATH = File.dirname(File.expand_path(__FILE__))

%w{app lib}.each do |dir|
  $LOAD_PATH.unshift File.join(ROOT_PATH, dir)
end
$stdout.sync = true # print the logs to stdout, logfile is bullshit

Struct.new('RACK_ENV') do
  DEFAULT = 'development'
  def env
    ENV['RACK_ENV'] || DEFAULT
  end

  %w{development production}.each do |environment|
    define_method :"#{environment}?" do
      env == environment
    end
  end

  def to_s
    env
  end
end

RACK_ENV = Struct::RACK_ENV.new

Bundler.require(:default, RACK_ENV.env)

database = YAML.load(File.new(ROOT_PATH + "/config/database.yml"))

if RACK_ENV.production?
  DataMapper::Logger.new($stdout, :info)
  DataMapper.setup(:default, ENV['CLEARDB_DATABASE_URL'])
else
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "sqlite3://#{ROOT_PATH}/#{database[RACK_ENV.env]['database']}")
end
