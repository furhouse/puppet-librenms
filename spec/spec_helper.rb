require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec_helper'
require 'yaml'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules') + ':~/localch/vcs/environments/production/modules'
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.hiera_config = File.join(fixture_path, 'hiera/hiera.yaml')
  c.before(:all) do
    data = YAML.load_file(c.hiera_config)
    data[:yaml][:datadir] = File.join(fixture_path, 'hiera/data')
    File.open(c.hiera_config, 'w') do |f|
      f.write data.to_yaml
    end
  end
end
