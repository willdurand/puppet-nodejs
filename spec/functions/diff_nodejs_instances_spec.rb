require 'spec_helper'

describe 'diff_nodejs_instances' do
  it { should run.with_params(['v6.8.0', 'v6.9.0', 'v7.1.0'], ['v6.8.0', 'v7.1.0']).and_return(['v6.9.0']) }

  it { is_expected.to run.with_params().and_raise_error(/too few arguments/) } 
end
