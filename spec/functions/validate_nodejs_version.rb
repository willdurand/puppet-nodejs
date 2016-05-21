require 'spec_helper'

describe 'validate_nodejs_version' do
  it do
    expect {
      run.with_params('v0.6')
    }.to raise_error(Puppet::Error, /All NodeJS versions below `v0.10.0` are not supported!/)
  end

  describe 'outputs a warning for legacy versions' do
    run.with_params('v0.10')
    it do
      Puppet.expects('warning').with('All NodeJS versions below `v0.12.0` do work, but are not recommended to use!')
    end
  end
end
