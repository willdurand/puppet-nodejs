require 'spec_helper'

describe 'nodejs::evaluate_version' do
  it { should run.with_params('latest').and_return('v6.3.1') }
  it { should run.with_params('lts').and_return('v4.4.7') }
  it { should run.with_params('4.4.7').and_return('v4.4.7') }
  it { should run.with_params('v4.4.7').and_return('v4.4.7') }
  it { should run.with_params('any string').and_raise_error(Puppet::ParseError) }
  it { should run.with_params('6.3').and_return('v6.3.1') }
  it { is_expected.to run.with_params('6.x').and_return('v6.3.1') }
end
