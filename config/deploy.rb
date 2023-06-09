# config valid for current version and patch releases of Capistrano
lock '~> 3.17.2'
set :default_shell, '/bin/bash -l'
set :application, 'sales_forge'
set :repo_url, 'git@github.com:j-tee/sales-forge.git'
set :tmp_dir, '/home/deploy/tmp'
set :assets_roles, []
set :rvm_type, :system
set :rvm_custom_path, '/home/deploy/.rvm/bin/rvm'
set :rvm_ruby_version, 'ruby-3.2.1'

set :user, 'deploy'
set :linked_files, %w[config/database.yml]
append :linked_files, 'config/master.key'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'development'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/sales-forge'

append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor',
       'storage'

# Set up Passenger
set :passenger_restart_with_touch, true
set :passenger_in_gemfile, true
set :passenger_restart_options, -> { "#{deploy_to}/current" }

set :default_shell, '/bin/bash -l'
set :ssh_options, {
  forward_agent: true,
  keys: %w[~/.ssh/id_ed25519],
  auth_methods: %w[publickey]
}
set :git_ssh_command, 'ssh -i ~/.ssh/id_ed25519'

namespace :deploy do
  desc 'Create the database'
  task :create_db do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          if test("[ -f #{release_path.join('config/database.yml')} ]")
            execute :bundle, :exec, 'rake db:create'
          else
            info 'Skipping db:create, database.yml not found'
          end
        end
      end
    end
  end

  # Run database migrations
  desc 'Run database migrations'
  task :migrate_db do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, 'rake db:migrate'
        end
      end
    end
  end

  # Restart the application after deployment
  after :publishing, :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # Run additional tasks after publishing is finished
  after :published, :create_db
  after :create_db, :migrate_db
end
set :default_env, {
  PATH: '$HOME/.rvm/bin:$PATH',
  GEM_HOME: '$HOME/.rvm/gems/ruby-3.2.1',
  GEM_PATH: '$HOME/.rvm/gems/ruby-3.2.1@global'
}

# set :default_env, {
#   PATH: '$HOME/.rvm/gems/ruby-3.2.1/bin:$HOME/.rvm/gems/ruby-3.2.1@global/bin:$HOME/.rvm/rubies/ruby-3.2.1/bin:$PATH'
# }
# set :default_env, {
#   PATH: '$HOME/.rvm/bin:$PATH',
#   RUBY_VERSION: 'ruby-3.2.1',
#   GEM_HOME: '$HOME/.rvm/gems/ruby-3.2.1',
#   GEM_PATH: '$HOME/.rvm/gems/ruby-3.2.1:$HOME/.rvm/gems/ruby-3.2.1@global'
# }
