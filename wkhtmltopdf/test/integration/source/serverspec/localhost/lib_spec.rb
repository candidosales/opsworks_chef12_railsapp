require 'spec_helper'

describe 'libraries' do
  let(:lib_dir) { '/usr/local/lib' }
  let(:version) { '0.12.1' }

  describe file('/usr/local/lib/libwkhtmltox.so.0.12.1') do
    it { should be_file }
  end

  describe file('/usr/local/lib/libwkhtmltox.so.0.12') do
    it { should be_symlink }
    it { should be_linked_to "#{lib_dir}/libwkhtmltox.so.#{version}" }
  end

  describe file('/usr/local/lib/libwkhtmltox.so.0') do
    it { should be_symlink }
    it { should be_linked_to "#{lib_dir}/libwkhtmltox.so.#{version}" }
  end
end
