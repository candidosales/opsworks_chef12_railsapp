if node[:ec2] && (node[:ec2][:instance_type] == 't1.micro' ||
  node['opsworks_initial_setup']['swapfile_instancetypes'] && node['opsworks_initial_setup']['swapfile_instancetypes'].include?(node[:ec2][:instance_type]))
  include_recipe 'opsworks_initial_setup::swap'
end
