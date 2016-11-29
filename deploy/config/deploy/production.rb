set :rails_env, "production"
set :unicorn_rack_env, "production"

role :app, %w{sakura} # ホスト名
