require 'dalli'

memcached_options = {
  username: ENV['MEMCACHED_USERNAME'],
  password: ENV['MEMCACHED_PASSWORD'],
  failover: true,
  socket_timeout: 1.5,
  socker_failure_delay: 0.2
}
CACHE = Dalli::Client.new((ENV['MEMCACHED_SERVERS'] ||"").split(','), memcached_options)
