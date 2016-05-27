require 'spec_helper'

describe 'nodejs_latest_version' do
  it { should run.with_params().and_return('v6.1.0') }
end
