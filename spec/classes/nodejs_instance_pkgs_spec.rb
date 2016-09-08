require 'spec_helper'

describe 'nodejs::instance::pkgs', :type => :class do
  let(:title) { 'nodejs::instance::pkgs' }

  describe 'module dependency management' do
    it { should contain_package('curl') }
    it { should contain_package('tar') }
    it { should contain_package('ruby') }
    it { should contain_package('git') }

    it { should contain_package('semver') \
      .with_provider('gem') \
    }
  end
end
