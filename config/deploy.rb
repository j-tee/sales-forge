# config valid for current version and patch releases of Capistrano
lock '~> 3.17.2'

set :application, 'sales_forge'
set :repo_url, 'git@github.com:j-tee/sales-forge.git'
set :tmp_dir, '/home/deploy/tmp'
set :assets_roles, []

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
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor', 'storage'

set :default_shell, '/bin/bash -l'
set :ssh_options, {
  forward_agent: true,
  keys: %w[~/.ssh/id_ed25519],
  auth_methods: %w[publickey]
}
set :git_ssh_command, 'ssh -i ~/.ssh/id_ed25519'

namespace :deploy do
  desc 'Copy required files'
  task :copy_required_files do
    on roles(:app) do
      upload! 'config/master.key', "#{release_path}/config/master.key"
      upload! 'config/database.yml', "#{release_path}/config/database.yml"
      upload! '.env', "#{release_path}/.env"
    end
  end

  before 'deploy:assets:precompile', 'copy_required_files'

  task :seed do
    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # Exclude the problematic migration
          exclude_migration = '20230511174738_add_unconfirmed_email_to_user'
          exclude_arg = "--skip=#{exclude_migration}"

          execute :rake, "db:seed #{exclude_arg}"
        end
      end
    end
  end

  after :published, :create_db do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          if test("bundle exec rails dbconsole -e production -c 'SELECT datname FROM pg_database WHERE datname = \"#{fetch(:application)}\"' | grep -q \"#{fetch(:application)}\"")
            info 'Skipping db:create, database already exists'
          else
            execute :rake, 'db:create'
          end
        end
      end
    end
  end

  desc 'Setup a new deployment'
  task :setup do
    on roles(:app) do
      # Run setup commands here
      # For example, creating required directories, setting up environment variables, etc.
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :published, :restart
end

set :default_env, {
  PATH: '$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH'
}
