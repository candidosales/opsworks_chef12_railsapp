#
# Cookbook Name:: sneakers_worker
# Recipe:: restart
#
# Copyright 2013, FreeRunning Technologies
#
# All rights reserved - Do Not Redistribute
#

bash "restart-all-sneakers_worker" do
  user 'root'
  retries 10
  retry_delay 6
  code <<CODE
monit reload
sleep 1
monit -g sneakers_worker restart
CODE
end
