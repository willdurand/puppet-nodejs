require 'spec_helper'

describe 'nodejs_stable_version' do
  it { should run.with_params().and_return('v0.10.14') }
end
