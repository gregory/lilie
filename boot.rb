require 'rubygems'
require 'bundler/setup'

ROOT_PATH = File.dirname(File.expand_path(__FILE__))

$LOAD_PATH.unshift File.join(ROOT_PATH, 'lib')
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

