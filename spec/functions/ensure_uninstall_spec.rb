require 'spec_helper'

describe 'ensure_uninstall' do
  it { should run.with_params(['v6.8.0']).and_return({
    "nodejs-uninstall-custom-v6.8.0" => {
      :version => "v6.8.0"
    }
  })}

  it { is_expected.to run.with_params().and_raise_error(/too few arguments/) }
end
