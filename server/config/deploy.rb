require "dotenv"
require "yaml"
require 'pry'
Dotenv.load
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, ENV["HOST"]
user = ENV["SERVER_NAME"]

task :setup, roles: :app do
  run "useradd #{user} && su #{user} && usermod -G wheel #{user}"
  run "mkdir /home/#{user}/.ssh && chmod 700 /home/#{user}/.ssh && chown #{user}:#{user} /home/#{user}/.ssh"
  upload("./authorized_keys", "/home/#{user}/.ssh/authorized_keys", via: :scp, recursive: true)
  run "chmod 600 /home/#{user}/.ssh/authorized_keys && chown #{user}:#{user} /home/#{user}/.ssh/authorized_keys"
  run "echo %wheel ALL=NOPASSWD: ALL >> /etc/sudoers"
end
