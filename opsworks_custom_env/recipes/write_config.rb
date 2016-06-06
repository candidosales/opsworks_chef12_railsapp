# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107

node[:deploy].each do |application, deploy|
  app_data_bag = search('aws_opsworks_app').first
  Chef::Log.info("ENV VARS #{app_data_bag[:environment]}")
  custom_env_template do
    application application
    deploy deploy
    env OpsWorks::Escape.escape_double_quotes(app_data_bag[:environment])
  end
  
end
