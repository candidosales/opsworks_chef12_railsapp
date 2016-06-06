include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'freebsd::pkgng' if node['platform_family'] == 'freebsd'

node['wkhtmltopdf']['dependency_packages'].each do |p|
  package p
end

include_recipe "wkhtmltopdf::#{node['wkhtmltopdf']['install_method']}"
