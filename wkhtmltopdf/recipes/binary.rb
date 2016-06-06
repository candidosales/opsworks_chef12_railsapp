cache_dir = Chef::Config[:file_cache_path]
download_dest = File.join(cache_dir, node['wkhtmltopdf']['archive'])

remote_file download_dest do
  source node['wkhtmltopdf']['mirror_url']
  mode '0644'
  action :create_if_missing
  not_if { node['platform_family'] == 'freebsd' }
end

case node['platform_family']
when 'mac_os_x', 'mac_os_x_server'
  execute 'install_wkhtmltox' do
    command "installer -pkg #{download_dest} -target /"
  end
when 'windows'
  execute 'install_wkhtmltox' do
    command download_dest
  end
when 'debian'
  dpkg_package 'wkhtmltox' do
    source download_dest
  end
when 'rhel', 'fedora'
  rpm_package 'wkhtmltox' do
    source download_dest
  end
when 'freebsd'
  # Force support pkgng as it seems to check before freebsd::pkgng is run
  Chef::Resource::FreebsdPackage.class_eval do
    def supports_pkgng?
      true
    end
  end
  package 'wkhtmltopdf' do
    version node['wkhtmltopdf']['version']
  end
end
