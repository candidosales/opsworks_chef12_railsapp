include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not a Rails app")
    next
  end

  rds_db_instance = search('aws_opsworks_rds_db_instance').first

  case rds_db_instance[:engine]
  when "mysql"
    include_recipe "mysql::client_install"
  when "postgresql"
    include_recipe "opsworks_postgresql::client_install"
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_rails do
    deploy_data deploy
    app application
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
end