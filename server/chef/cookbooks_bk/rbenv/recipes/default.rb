#
# Cookbook Name:: common_packages
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "git"

# rbenv install dir
install_dir  = "/usr/local"
package_name = "rbenv"
rbenv_root   = "#{install_dir}/#{package_name}"

# rbenv plugin
rbenv_plugin_path = "#{rbenv_root}/plugins"
ruby_build        = "ruby_build"
ruby_build_path   = "#{rbenv_plugin_path}/#{ruby_build}"

# .bash_profile
bash_profile      = ".bash_profile"

# install ruby version
ruby_version = "2.3.1"

rbenv_versions = "#{rbenv_root}/versions"
rbenv_ruby_root = "#{rbenv_versions}/#{ruby_version}"

# package
package "gcc"
yum_package "openssl-devel"
yum_package "readline-devel"

# git clone rbenv repository
bash "git-clone-rbenv" do
  user "root"
  flags "-e"

  code <<-EOH
    git clone https://github.com/sstephenson/rbenv.git #{install_dir}/#{package_name}
    git clone https://github.com/sstephenson/ruby-build.git #{ruby_build_path}
  EOH

  not_if { File.exists? rbenv_root }
end


# set rbenv users
node[:rbenv][:users].each do |user|
  path = `echo ~#{user}`.chomp
  path += "/#{bash_profile}"

  bash "set #{path}" do
    user "root"
    flags "-e"
    code <<-EOH
    echo 'export RBENV_ROOT=#{rbenv_root}' >> #{path}
    echo 'export PATH=$RBENV_ROOT/bin:$PATH' >> #{path}
    echo 'eval "$(rbenv init -)"' >> #{path}
    EOH

    not_if "grep -i #{package_name} #{path}"
  end
end


# install rbenv
bash "install-rbenv" do
  cwd install_dir
  user "root"
  flags "-e"
  code <<-EOH
  export RBENV_ROOT=#{rbenv_root}
  export PATH=$RBENV_ROOT/bin:$PATH
  cd #{package_name}
  rbenv install #{ruby_version}
  rbenv rehash
  rbenv global #{ruby_version}
  EOH

  not_if { File.exists? rbenv_ruby_root }
end

# install gem
execute "install-bundler" do
  command "#{rbenv_root}/shims/gem install bundler"
  not_if "#{rbenv_root}/shims/gem -list | grep bundler"
end
