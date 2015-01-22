preload_app true

after_fork do |server, worker|
  Rigidoj.after_fork
end
