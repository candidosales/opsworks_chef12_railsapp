require 'spec_helper'

case os[:family]
when 'freebsd'
  describe package('wkhtmltopdf'), if: os[:release].to_f >= 10.0 do
    it { should be_installed.with_version('0.12.1') }
  end

  describe command('pkg query %v wkhtmltopdf'), if: os[:release].to_f < 10.0 do
    its(:stdout) { should match(/\b0\.12\.1(?:_.*)?\b/) }
    its(:exit_status) { should eq(0) }
  end

else
  describe package('wkhtmltox'), unless: os[:family] == 'freebsd' do
    it { should be_installed.with_version('0.12.1') }
  end
end
