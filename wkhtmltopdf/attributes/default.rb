default['wkhtmltopdf']['version']        = '0.12.1'
default['wkhtmltopdf']['install_method'] = 'binary'
default['wkhtmltopdf']['install_dir']    = '/usr/local/bin'
default['wkhtmltopdf']['lib_dir']        = ''

case node['platform_family']
when 'mac_os_x', 'mac_os_x_server'
  default['wkhtmltopdf']['dependency_packages'] = []
  default['wkhtmltopdf']['suffix'] = 'pkg'
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['platform'] = 'osx-cocoa'
    default['wkhtmltopdf']['architecture'] = 'x86_64'
  else
    default['wkhtmltopdf']['platform'] = 'osx-carbon'
    default['wkhtmltopdf']['architecture'] = 'i386'
  end

when 'windows'
  default['wkhtmltopdf']['dependency_packages'] = []
  default['wkhtmltopdf']['suffix'] = 'exe'
  default['wkhtmltopdf']['platform'] = 'mingw-w64-cross'
  # or default['wkhtmltopdf']['platform'] = 'msvc2013'
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['architecture'] = 'win64'
  else
    default['wkhtmltopdf']['architecture'] = 'win32'
  end

when 'debian'
  jpeg_package = 'libjpeg8'
  platform_version = node['platform_version']
  default['wkhtmltopdf']['suffix'] = 'deb'
  if platform?('debian')
    default['wkhtmltopdf']['platform'] = 'linux-wheezy'
  elsif platform?('ubuntu')
    if Chef::VersionConstraint.new('>= 14.04').include?(platform_version)
      jpeg_package = 'libjpeg-turbo8'
      default['wkhtmltopdf']['platform'] = 'linux-trusty'
    elsif Chef::VersionConstraint.new('>= 12.04').include?(platform_version)
      default['wkhtmltopdf']['platform'] = 'linux-precise'
    end
  end
  default['wkhtmltopdf']['dependency_packages'] = %W(fontconfig libfontconfig1 libfreetype6 libpng12-0 zlib1g #{jpeg_package} libssl1.0.0 libx11-6 libxext6 libxrender1 libstdc++6 libc6)
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['architecture'] = 'amd64'
  else
    default['wkhtmltopdf']['architecture'] = 'i386'
  end

when 'rhel', 'fedora'
  jpeg_package = 'libjpeg'
  default['wkhtmltopdf']['suffix'] = 'rpm'
  if node['platform_family'] == 'fedora'
    jpeg_package = 'libjpeg-turbo'
    default['wkhtmltopdf']['platform'] = 'linux-centos6'
  elsif Chef::VersionConstraint.new('>= 7.0').include?(node['platform_version'])
    if node['kernel']['machine'] == 'x86_64'
      jpeg_package = 'libjpeg-turbo'
      default['wkhtmltopdf']['platform'] = 'linux-centos7'
    else
      default['wkhtmltopdf']['platform'] = 'linux-centos6'
    end
  elsif Chef::VersionConstraint.new('>= 6.0').include?(node['platform_version'])
    default['wkhtmltopdf']['platform'] = 'linux-centos6'
  else
    default['wkhtmltopdf']['platform'] = 'linux-centos5'
  end
  default['wkhtmltopdf']['dependency_packages'] = %W(fontconfig freetype libpng zlib #{jpeg_package} openssl libX11 libXext libXrender libstdc++ glibc)
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['architecture'] = 'amd64'
  else
    default['wkhtmltopdf']['architecture'] = 'i386'
  end

when 'freebsd'
  default['wkhtmltopdf']['dependency_packages'] = %w(fontconfig freetype2 jpeg png libiconv libX11 libXext libXrender)

else
  default['wkhtmltopdf']['install_method'] = 'source'
  default['wkhtmltopdf']['dependency_packages'] = []
end

if node['wkhtmltopdf']['install_method'] == 'source'
  case node['platform_family']
  when 'debian'
    jpeg_package = 'libjpeg8-dev'
    if platform?('ubuntu') && Chef::VersionConstraint.new('>= 14.04').include?(platform_version)
      jpeg_package = 'libjpeg-turbo8-dev'
    end
    default['wkhtmltopdf']['dependency_packages'] = %W(build-essential libfontconfig-dev libfreetype6-dev libpng12-0-dev zlib1g-dev #{jpeg_package} libssl-dev libx11-dev libxext-dev libxrender-dev libc6-dev)
  when 'rhel', 'fedora'
    jpeg_package = 'libjpeg-devel'
    if node['platform_family'] == 'fedora' || Chef::VersionConstraint.new('>= 6.0').include?(node['platform_version'])
      jpeg_package = 'libjpeg-turbo-devel'
    end
    default['wkhtmltopdf']['dependency_packages'] = %W(patch gcc-c++ fontconfig-devel freetype-devel libpng-devel zlib-devel #{jpeg_package} openssl-devel libX11-devel libXext-devel libXrender-devel libstdc++-devel glibc-devel)
  when 'freebsd'
    default['wkhtmltopdf']['dependency_packages'] = %w(gcc fontconfig freetype2 jpeg png pkgconf gmake libX11 libXext libXrender perl5 libiconv)
  end
  default['wkhtmltopdf']['suffix'] = 'tar.bz2'
  default['wkhtmltopdf']['platform'] = ''
  default['wkhtmltopdf']['architecture'] = ''
  default['wkhtmltopdf']['archive'] = "wkhtmltox-#{node['wkhtmltopdf']['version']}.#{node['wkhtmltopdf']['suffix']}"
  default['wkhtmltopdf']['extracted_name'] = "wkhtmltox-#{node['wkhtmltopdf']['version']}"
  default['wkhtmltopdf']['build_target'] = 'posix-local'
  default['wkhtmltopdf']['build_cache_path'] = ''
else
  default['wkhtmltopdf']['archive'] = "wkhtmltox-#{node['wkhtmltopdf']['version']}_#{node['wkhtmltopdf']['platform']}-#{node['wkhtmltopdf']['architecture']}.#{node['wkhtmltopdf']['suffix']}"
end

parent_folder = node['wkhtmltopdf']['version'].split('.').take(2).join('.')
default['wkhtmltopdf']['mirror_url'] = "http://download.gna.org/wkhtmltopdf/#{parent_folder}/#{node['wkhtmltopdf']['version']}/#{node['wkhtmltopdf']['archive']}"
