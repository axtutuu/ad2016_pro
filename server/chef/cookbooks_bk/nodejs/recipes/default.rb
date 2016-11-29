#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "node-repo" do
  code "curl -sL https://rpm.nodesource.com/setup_5.x | bash -"
  not_if "yum list installed | grep node"
end

package "nodejs"
