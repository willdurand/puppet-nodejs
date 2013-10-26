require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }

  let(:facts) {{
    :nodejs_stable_version => 'v0.10.20'
  }}

  describe 'with default parameters' do
    it { should contain_nodejs__install('nodejs-stable') \
      .with_version('stable') \
      .with_target_dir('/usr/local/bin') \
      .with_with_npm('true') \
      .with_make_install('true')
    }

    it { should contain_file('/usr/local/bin/node') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v0.10.20/bin/node')
    }

    it { should contain_file('/usr/local/bin/npm') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v0.10.20/bin/npm')
    }
  end

  describe 'with a given version' do
    let(:params) {{
      :version  => 'v0.10.0',
    }}

    it { should contain_nodejs__install('nodejs-v0.10.0') \
      .with_version('v0.10.0')
    }

    it { should contain_file('/usr/local/bin/node') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v0.10.0/bin/node')
    }
  end

  describe 'with a given target_dir' do
    let(:params) {{
      :target_dir  => '/bin',
    }}

    it { should contain_nodejs__install('nodejs-stable') \
      .with_target_dir('/bin') \
    }
  
    it { should contain_file('/bin/node') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v0.10.20/bin/node')
    }
  end

  describe 'without NPM' do
    let(:params) {{
      :with_npm => false
    }}

    it { should contain_nodejs__install('nodejs-stable') \
      .with_with_npm('false')
    }

    it { should_not contain_file('/usr/local/bin/npm') }
  end

  describe 'with make_install = false' do
    let(:params) {{
      :make_install => false
    }}

    it { should contain_nodejs__install('nodejs-stable') \
      .with_make_install('false')
    }
  end
end
