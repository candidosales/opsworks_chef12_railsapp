include_recipe "chef_opsworks_elb"

if node[:opsworks][:instance][:layers].include?('rails-app')
  java_home = node['aws']['elb']['java_home']

  node['aws']['elbs'].each do |elb|
    execute "register" do
      command "/usr/bin/env JAVA_HOME=#{java_home} AWS_ELB_HOME=#{node['aws']['elb']['cli_install_path']}/elb #{node['aws']['elb']['cli_install_path']}/elb/bin/elb-cmd elb-register-instances-with-lb #{elb[:load_balancer_name]} --instances '#{node[:opsworks][:instance][:aws_instance_id]}' --region #{node[:opsworks][:instance][:region]} --access-key-id '#{node['aws']['AWS_ACCESS_KEY_ID']}' --secret-key '#{node['aws']['AWS_SECRET_ACCESS_KEY']}'"
      user "root"
    end
  end
end
