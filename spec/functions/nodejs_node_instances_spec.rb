require 'spec_helper'

describe 'nodejs::node_instances' do
  it {
    should run.with_params(
      { "node-instance" => { "version" => "latest" } },
      true
    ).and_return({ "nodejs-custom-instance-v6.3.1" => {
      "version" => "v6.3.1"
    }})
  }

  it { should run.with_params(['v6.8.0']).and_return({
    "nodejs-uninstall-custom-v6.8.0" => {
      "version" => "v6.8.0"
    }
  })}

  it { should run.with_params(['latest']).and_return({
    "nodejs-uninstall-custom-v6.3.1" => {
      "version" => "v6.3.1"
    }
  })}

  it { should run.with_params(
    { "node-instance" => { "source" => "https://my-repo.local/node.tar.gz" }},
    true
  ).and_return({ "nodejs-custom-instance-https://my-repo.local/node.tar.gz" => {
    "source"  => "https://my-repo.local/node.tar.gz",
  }})}
end
