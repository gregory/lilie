environment ENV['RACK_ENV'] || 'development'
port ENV['PORT'] || '3000'
preload_app!
