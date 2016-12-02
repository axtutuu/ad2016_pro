# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'linebot_v1'
set :repo_url, 'git@github.com:pocke777/linebot_v1.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :branch, 'master' # デプロイしたいブランチ名
set :deploy_to, '/var/www/sites/linebot_v1' # デプロイ先サーバのディレクトリ
set :scm, :git
set :log_level, :debug
set :pty, true
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets bundle public/system}
set :linked_files, %w{db/config.yml}
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }
set :keep_releases, 5

set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }
set :rbenv_ruby, '2.3.1'
set :rbenv_custom_path, '/usr/local/rbenv'
# after  "deploy:publishing", 'unicorn:restart'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
