require 'spec_helper'

describe 'nodejs_latest_version' do
  it { should run.with_params().and_return('v0.11.16') }
end
