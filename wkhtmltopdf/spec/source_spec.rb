require 'spec_helper'

describe 'wkhtmltopdf::source' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['wkhtmltopdf']['install_method'] = 'source'
      node.set['wkhtmltopdf']['install_dir'] = install_dir
      node.set['wkhtmltopdf']['build_cache_path'] = cache_dir
    end.converge(described_recipe)
  end

  before do
    stub_command("test -f #{extracted_path}/static-build/wkhtmltox-#{version}_local-`hostname`.tar.xz").and_return(false)
    allow(FileUtils).to receive(:mkdir_p).with(cache_dir).and_return(true)
  end

  let(:cache_dir) { '/test/cache' }
  let(:version) { '0.12.1' }
  let(:archive) { "wkhtmltox-#{version}.tar.bz2" }
  let(:download_dest) { File.join(cache_dir, archive) }
  let(:install_dir) { '/test/bin' }
  let(:extracted_path) { File.join(cache_dir, "wkhtmltox-#{version}") }
  let(:build_target) { 'posix-local' }
  let(:static_build_path) { File.join(extracted_path, 'static-build', build_target, "wkhtmltox-#{version}") }

  it { expect(chef_run).to create_remote_file_if_missing(download_dest) }
  it 'extracts archive' do
    expect(chef_run).to run_execute('extract_wkhtmltopdf')
      .with_cwd(cache_dir)
      .with_command("tar -xjf #{download_dest}")
  end
  it 'builds wkhtmltox' do
    expect(chef_run).to run_execute('build_wkhtmltox')
      .with_cwd(extracted_path)
      .with_command("scripts/build.py #{build_target}")
  end
  it 'installs wkhtmltoimage' do
    expect(chef_run).to run_execute('install_wkhtmltoimage')
      .with_cwd(static_build_path)
      .with_command("cp bin/wkhtmltoimage #{install_dir}/wkhtmltoimage")
  end
  it 'installs wkhtmltopdf' do
    expect(chef_run).to run_execute('install_wkhtmltopdf')
      .with_cwd(static_build_path)
      .with_command("cp bin/wkhtmltopdf #{install_dir}/wkhtmltopdf")
  end

  context 'with version 0.12.1' do
    let(:version) { '0.12.1' }
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['wkhtmltopdf']['install_method'] = 'source'
        node.set['wkhtmltopdf']['version'] = version
        node.set['wkhtmltopdf']['build_cache_path'] = cache_dir
      end.converge(described_recipe)
    end

    it 'creates build patch file' do
      expect(chef_run).to render_file(File.join(extracted_path, 'build_fixtar.patch'))
    end

    it 'patches build.py' do
      expect(chef_run).to run_execute('patch_wkhtmltox_build')
        .with_cwd(extracted_path)
        .with_command('patch -N -p0 < build_fixtar.patch')
    end
  end

  context 'with lib_dir' do
    let(:lib_dir) { '/usr/local/lib' }
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['wkhtmltopdf']['install_method'] = 'source'
        node.set['wkhtmltopdf']['lib_dir'] = lib_dir
        node.set['wkhtmltopdf']['build_cache_path'] = cache_dir
      end.converge(described_recipe)
    end

    it do
      expect(chef_run).to run_execute('install_wkhtmltox_so')
        .with_cwd(static_build_path)
        .with_command("cp lib/libwkhtmltox.so.#{version} #{lib_dir}/libwkhtmltox.so.#{version}")
    end
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.0.12")
        .with_to("#{lib_dir}/libwkhtmltox.so.#{version}")
    end
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.0")
        .with_to("#{lib_dir}/libwkhtmltox.so.#{version}")
    end
  end
end
