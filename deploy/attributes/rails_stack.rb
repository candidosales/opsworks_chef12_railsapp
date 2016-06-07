###
# Do not use this file to override the deploy cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "deploy/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'deploy/attributes/rails_stack.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

class AttributeSearch
  extend Chef::DSL::DataQuery
end

layer = OpsWorks::ResolveLayer.resolve_current_layer(AttributeSearch.search('aws_opsworks_layer'))
layer_name = layer['shortname']
Chef::Log.info("*** LAYER NAMES ARE #{layer}")
normal[:opsworks][:rails_stack][:name] = node[:rails_stack][layer_name] ? node[:rails_stack][layer_name][:name] : 'nginx_unicorn'

case node[:opsworks][:rails_stack][:name]
when "apache_passenger"
  normal[:opsworks][:rails_stack][:recipe] = "passenger_apache2::rails"
  normal[:opsworks][:rails_stack][:needs_reload] = true
  normal[:opsworks][:rails_stack][:service] = 'apache2'
  normal[:opsworks][:rails_stack][:restart_command] = 'touch tmp/restart.txt'
when "nginx_unicorn"
  normal[:opsworks][:rails_stack][:recipe] = "unicorn::rails"
  normal[:opsworks][:rails_stack][:needs_reload] = true
  normal[:opsworks][:rails_stack][:service] = 'unicorn'
  normal[:opsworks][:rails_stack][:restart_command] = "../../shared/scripts/unicorn restart"
end

include_attribute "deploy::customize"
