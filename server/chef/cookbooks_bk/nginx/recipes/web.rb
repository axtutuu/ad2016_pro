# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
pp node[:nginx]
options = node[:nginx]

template "/etc/nginx/allow_ips.conf" do
  source "allow_ips.conf.erb"
  owner "root"
  mode "0644"
end

template "/etc/nginx/conf.d/#{options[:domains][0]}.conf" do
  owner    "root"
  mode     0644
  source   "web.conf.erb"
  variables(
    domains: options[:domains],
    root: options[:root],
  )

  notifies :reload, "service[nginx]"
end
