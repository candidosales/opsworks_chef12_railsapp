user_account 'deploy' do
  create_group true
end

group 'sudo' do
  action :modify
  members 'deploy'
  append true
end

cookbook_file 'id_rsa' do
  source 'id_rsa'
  path '/home/deploy/.ssh/id_rsa'
  group 'deploy'
  owner 'deploy'
  mode 0600
  action :create
end

cookbook_file 'id_rsa.pub' do
  source 'id_rsa.pub'
  path '/home/deploy/.ssh/id_rsa.pub'
  group 'deploy'
  owner 'deploy'
  mode 0644
  action :create
end

# Allow sudo command without password for sudoers
cookbook_file 'sudo_without_password' do
  source 'sudo_without_password'
  path '/etc/sudoers.d/sudo_without_password'
  group 'root'
  owner 'root'
  mode 0440
  action :create
end

# Authorize yourself to connect to server
cookbook_file 'authorized_keys' do
  source 'authorized_keys'
  path '/home/deploy/.ssh/authorized_keys'
  group 'deploy'
  owner 'deploy'
  mode 0600
  action :create
end
