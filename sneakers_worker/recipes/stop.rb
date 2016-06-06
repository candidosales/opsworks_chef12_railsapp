# Adapted from nginx::stop: https://github.com/aws/opsworks-cookbooks/blob/master/nginx/recipes/stop.rb

node[:deploy].each do |application, deploy|

  execute "stop Rails app #{application}" do
    command "sudo monit -g sneakers_worker stop"
  end

end
