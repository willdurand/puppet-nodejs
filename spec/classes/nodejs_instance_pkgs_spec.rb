require 'spec_helper'

describe 'nodejs::instance::pkgs', :type => :class do
  let(:title) { 'nodejs::instance::pkgs' }

  describe 'module dependency management' do
    it { should contain_package('wget') }
    it { should contain_package('tar') }
  end

  describe 'includes ruby dependency' do
    let(:params) {{
      :install_ruby => true
    }}

    it { should contain_package('wget') }
    it { should contain_package('tar') }

    # all packages are loaded, but ruby and the semver gem are available, too.
    it { should contain_package('ruby') }
    it { should contain_package('semver') \
      .with_provider('gem') \
    }
  end

  describe 'includes compiler-related dependencies' do
    let(:params) {{
      :make_install => true
    }}
    let(:facts) {{
      :osfamily => 'Debian'
    }}

    it { should contain_package('wget') }
    it { should contain_package('tar') }

    it { should contain_package('make') }
    it { should contain_class('gcc') }
  end
end
