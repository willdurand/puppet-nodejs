require 'spec_helper'

describe 'nodejs::validate_nodejs_version' do
  it { should run.with_params('v0.6.0').and_raise_error(Puppet::ParseError) }
end
