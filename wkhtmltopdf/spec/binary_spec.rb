require 'spec_helper'

describe 'wkhtmltopdf::binary' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  let(:cache_dir) { Chef::Config[:file_cache_path] }
  let(:version) { '0.12.1' }
  let(:archive) { "wkhtmltox-#{version}_#{platform}-#{architecture}.#{suffix}" }
  let(:download_dest) { File.join(cache_dir, archive) }

  context 'for ubuntu' do
    let(:platform) { 'linux-precise' }
    let(:architecture) { 'amd64' }
    let(:suffix) { 'deb' }

    it { expect(chef_run).to create_remote_file_if_missing(download_dest) }

    it do
      expect(chef_run).to install_dpkg_package('wkhtmltox')
        .with_source(download_dest)
    end
  end

  context 'for centos' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
        .converge(described_recipe)
    end

    let(:platform) { 'linux-centos6' }
    let(:architecture) { 'amd64' }
    let(:suffix) { 'rpm' }

    it { expect(chef_run).to create_remote_file_if_missing(download_dest) }

    it do
      expect(chef_run).to install_rpm_package('wkhtmltox')
        .with_source(download_dest)
    end
  end

  context 'for freebsd' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'freebsd', version: '9.2')
        .converge(described_recipe)
    end

    it do
      expect(chef_run).to install_package('wkhtmltopdf')
        .with_version(version)
    end
  end
end
