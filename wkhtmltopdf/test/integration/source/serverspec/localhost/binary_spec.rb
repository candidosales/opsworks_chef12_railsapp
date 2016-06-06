require 'spec_helper'

describe command('which wkhtmltoimage') do
  its(:exit_status) { should eq(0) }
end

describe command('which wkhtmltopdf') do
  its(:exit_status) { should eq(0) }
end
