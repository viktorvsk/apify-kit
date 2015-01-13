worker_processes 2
timeout 3000


listen "/tmp/unicorn.apify.sock"

app_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
working_directory app_path

# Unicorn PID file location
pid "#{app_path}/tmp/pids/unicorn.pid"

# Path to logs
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end
