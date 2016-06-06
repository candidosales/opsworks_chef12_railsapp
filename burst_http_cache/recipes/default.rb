node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping etag version initializer application #{application} as it is not an Rails app")
    next
  end

  execute "restart Rails app #{application} after creating etag version initializer" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    user deploy[:user]
    action :nothing
  end

  template "#{deploy[:deploy_to]}/shared/config/burst_http_cache.rb" do
    source 'burst_http_cache.erb'
    owner deploy[:user]
    group deploy[:group]
    mode '0660'
    variables etag_version_id: Time.now.to_i.to_s
    notifies :run, resources(:execute => "restart Rails app #{application} after creating etag version initializer")

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
end
