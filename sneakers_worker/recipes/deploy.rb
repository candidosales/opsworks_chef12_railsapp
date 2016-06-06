# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb
include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping sneakers_worker::deploy application #{application} as it is not an Rails app")
    next
  end

  Chef::Log.debug("sneakers_worker::deploy application #{application} as it is a worker app")

  # Write sneakers.rb initializer
  layer = search('aws_opsworks_layer').first['shortname']
  template "#{deploy[:deploy_to]}/shared/config/sneakers.rb" do
    source 'sneakers.rb.erb'
    owner deploy[:user]
    group deploy[:group]
    mode '0660'
    variables({vars: (node[:deploy][application][layer][:options] || {}), deploy_to_path: deploy[:deploy_to]})

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  node.set[:opsworks][:rails_stack][:recipe] = "sneakers_worker::setup"
  node.set[:opsworks][:rails_stack][:restart_command] = 'sleep 60 && sudo monit -g sneakers_worker restart'

  # This stops all delayed jobs which have a pid file
  bash "sneakers_worker-#{application}-stop" do
    cwd "#{deploy[:deploy_to]}"
    user 'deploy'
    code "kill -SIGTERM `cat shared/pids/sneakers.pid`"

    action :nothing
  end

  bash "sneakers_worker-#{application}-reload" do
    user 'root'

    # We unmonitor the delayed jobs because we will stop them manually
    # They will become monitored again when restarted
    # Sleeps after each command because monit does not wait for the server
    code <<CODE
monit -g sneakers_worker unmonitor
sleep 1
monit reload
sleep 1
CODE

    action :nothing
    subscribes :run, "template[/etc/monit.d/#{application}_sneakers_worker.monitrc]", :immediately
    notifies :run, "bash[sneakers_worker-#{application}-stop]", :immediately
  end
end

include_recipe 'sneakers_worker::restart'
