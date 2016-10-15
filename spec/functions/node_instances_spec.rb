require 'spec_helper'

describe 'node_instances' do
  before(:each) {
    Puppet::Parser::Functions.newfunction(:evaluate_version, :type => :rvalue) do |args|
      return 'v6.8.0'
    end
  }

  it {
    should run.with_params(
      { "node-instance" => { "version" => "latest" } }
    ).and_return({ "nodejs-custom-instance-v6.8.0" => {
      "version" => "v6.8.0"
    }})
  }
end
