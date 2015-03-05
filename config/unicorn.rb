# See http://unicorn.bogomips.org/Unicorn/Configurator.html

# enable out of band gc out of the box, it is low risk and improves perf a lot
ENV['UNICORN_ENABLE_OOBGC'] ||= "1"

rigidoj_path = File.expand_path(File.expand_path(File.dirname(__FILE__)) + "/../")

# tune down if not enough ram
worker_processes (ENV['UNICORN_WORKERS'] || 3).to_i

working_directory rigidoj_path

# listen "#{rigidoj_path}/tmp/sockets/unicorn.sock"
listen (ENV['UNICORN_PORT'] || 3000).to_i

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
pid "#{rigidoj_path}/tmp/pids/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, some applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path "#{rigidoj_path}/log/unicorn.stderr.log"
stdout_path "#{rigidoj_path}/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|

  ActiveRecord::Base.connection.disconnect!
  $redis.client.disconnect


  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  sleep 1
end

after_fork do |server, worker|
  Rigidoj.after_fork
end
