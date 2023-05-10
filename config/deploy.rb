# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "sales_forge"
set :repo_url, "git@github.com:j-tee/sales-forge.git"
set :tmp_dir, "/home/deploy/tmp"
set :assets_roles, []

set :user, 'deploy'
set :linked_files, %w{config/database.yml}
append :linked_files, 'config/master.key'



# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, "development"

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, "/var/www/sales-forge"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
 append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
 append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

 # Set up Passenger
set :passenger_restart_with_touch, true
set :passenger_in_gemfile, true
set :passenger_restart_options, -> { "#{deploy_to}/current" }

set :default_shell, '/bin/bash -l'
set :ssh_options, {
  forward_agent: true,
  keys: %w(~/.ssh/id_ed25519),
  auth_methods: %w(publickey)
}
set :git_ssh_command, "ssh -i ~/.ssh/id_ed25519"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :deploy do
  after :published, :create_db do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          unless test("bundle exec rails dbconsole -e production -c 'SELECT datname FROM pg_database WHERE datname = \"#{fetch(:application)}\"' | grep -q \"#{fetch(:application)}\"")
            execute :rake, 'db:create'
          else
            info 'Skipping db:create, database already exists'
          end
        end
      end
    end
  end
  desc "Setup a new deployment"
  task :setup do
    on roles(:app) do
      # Run setup commands here
      # For example, creating required directories, setting up environment variables, etc.
    end
  end
    desc "Restart application"
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        execute :touch, release_path.join("tmp/restart.txt")
      end
    end
  
    after :publishing, :restart
end
set :default_env, {
  PATH: "$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
}