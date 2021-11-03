# frozen_string_literal: true

rails_root = File.expand_path('..', __dir__)

worker_processes 2
working_directory rails_root
timeout 45

# preload_app true

listen "#{rails_root}/tmp/unicorn.sock"
pid "#{rails_root}/tmp/unicorn.pid"

# NOTE: ▼ stderr_path と stdout_path をコメントにすることで、ログ出力が標準出力へ切り替わる。
# stderr_path "#{rails_root}/log/unicorn_error.log"
# stdout_path "#{rails_root}/log/unicorn.log"

# before_fork do |server, worker|
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.connection.disconnect!
#   end

#   old_pid = "#{server.config[:pid]}.oldbin"
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#     end
#   end
# end

# after_fork do |server, worker|
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.establish_connection
#   end
# end
