
include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  layer = OpsWorks::ResolveLayer.resolve_current_layer(search('aws_opsworks_layer'))['shortname']

  template "/etc/monit/conf.d/#{application}_sneakers_worker.monitrc" do
    source 'sneakers_worker.monitrc.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :app => application,
      :env => deploy[:rails_env],
      :dir => deploy[:deploy_to],
      :user => deploy[:user],
      :group => deploy[:group],
      :workers => deploy[layer][:sneakers_worker] && deploy[layer][:sneakers_worker].join(',')
    )
    only_if { deploy[layer][:sneakers_worker] }
  end
end
