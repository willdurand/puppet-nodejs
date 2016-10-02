require 'spec_helper'

describe 'nodejs::instance::pkgs', :type => :class do
  let(:title) { 'nodejs::instance::pkgs' }

  describe 'module dependency management' do
    it { should contain_package('curl') }
    it { should contain_package('tar') }
    it { should contain_package('git') }
  end

  describe 'includes ruby dependency' do
    let(:params) {{
      :contain_ruby => true
    }}

    it { should contain_package('curl') }
    it { should contain_package('tar') }
    it { should contain_package('git') }

    # all packages are loaded, but ruby and the semver gem are available, too.
    it { should contain_package('ruby') }
    it { should contain_package('semver') \
      .with_provider('gem') \
    }
  end
end
