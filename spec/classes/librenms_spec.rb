# for rspec-puppet documentation - see http://rspec-puppet.com/tutorial/
require_relative '../spec_helper'

describe 'librenms' do
  #mock the hostname so it matches the hiera
  #hierarchy when testing.
  let(:facts) { {:hostname => 'host-dev-dc01'} }
  
  it 'should do something'
end
