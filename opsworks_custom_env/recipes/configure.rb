layer = OpsWorks::ResolveLayer.resolve_current_layer(search('aws_opsworks_layer'))

if %w(rails-app rails-app2 sidekiq recurring mq).include?(layer['shortname']) ||
  (node[:opsworks][:instance][:layers] & (node[:set_env_for] || [])).size > 0

  include_recipe "opsworks_custom_env::restart_command"
  include_recipe "opsworks_custom_env::write_config"

end
