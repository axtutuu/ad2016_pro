#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "nginx"

service "nginx" do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

directory '/etc/nginx/conf.d' do
  recursive true
  mode 0755
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644

  notifies :reload, "service[nginx]"
end
