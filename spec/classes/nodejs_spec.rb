require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }

  let(:facts) {{
    :kernel         => 'linux',
    :hardwaremodel  => 'x86',
    :osfamily       => 'Ubuntu',
    :processorcount => 2,
  }}

  before(:each) {
     Puppet::Parser::Functions.newfunction(:nodejs_stable_version, :type => :rvalue) {
         |args| 'v6.0.0'
     }
     Puppet::Parser::Functions.newfunction(:nodejs_latest_version, :type => :rvalue) {
         |args| 'v6.0.1'
     }
     Puppet::Parser::Functions.newfunction(:validate_nodejs_version) {
         |args| 'v6.2.0'
     }
   }

  describe 'with default parameters' do
    it { should contain_nodejs__install('nodejs-stable') \
      .with_version('v6.0.0') \
      .with_target_dir('/usr/local/bin') \
      .with_make_install('true')
    }

    it { should contain_file('/usr/local/node/node-default') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v6.0.0')
    }

    it { should contain_file('/etc/profile.d/nodejs.sh') }
  end

  describe 'with latest version' do
    let(:params) {{
      :version  => 'latest',
    }}

    it { should contain_nodejs__install('nodejs-latest') \
      .with_version('v6.0.1') \
      .with_target_dir('/usr/local/bin') \
      .with_make_install('true')
    }

    it { should contain_file('/usr/local/node/node-default') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v6.0.1')
    }

    it { should contain_file('/etc/profile.d/nodejs.sh') }
  end

  describe 'with a given version' do
    let(:params) {{
      :version  => 'v5.0.0',
    }}

    it { should contain_nodejs__install('nodejs-v5.0.0') \
      .with_version('v5.0.0')
    }

    it { should contain_file('/usr/local/node/node-default') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v5.0.0')
    }
  end

  describe 'with a given target_dir' do
    let(:params) {{
      :target_dir  => '/bin',
    }}

    it { should contain_nodejs__install('nodejs-stable') \
      .with_target_dir('/bin') \
    }
  end

  describe 'with make_install = false' do
    let(:params) {{
      :make_install => false
    }}

    it { should contain_nodejs__install('nodejs-stable') \
      .with_make_install('false')
    }
  end

  describe 'with node_path' do
    let(:params) {{
      :node_path => '/usr/local/node/node-v5.4.1/lib/node_modules'
    }}

    it { should contain_file('/etc/profile.d/nodejs.sh') \
      .with_content(/(.*)NODE_PATH=\/usr\/local\/node\/node-v5.4.1\/lib\/node_modules/)
    }
  end
end
