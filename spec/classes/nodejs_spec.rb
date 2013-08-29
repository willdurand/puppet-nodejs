require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }

  it { should contain_file('/usr/local/node').with_ensure('directory') }

  it { should contain_exec('nodejs-download-latest') \
    .with_command('wget http://nodejs.org/dist/node-latest.tar.gz') \
    .with_cwd('/usr/local/node') \
    .with_unless('test -f node-latest.tar.gz')
  }

  it { should contain_exec('nodejs-unpack-latest') \
    .with_command('tar xzvf node-latest.tar.gz && mv `ls -rd node-v*` node-latest') \
    .with_cwd('/usr/local/node') \
    .with_unless('test -d node-latest')
  }

  it { should contain_exec('nodejs-install-latest') \
    .with_cwd('/usr/local/node/node-latest') \
    .with_unless('test -f /usr/local/node/node-latest/node')
  }

  it { should contain_exec('nodejs-symlink-bin-latest') \
    .with_command('ln -s /usr/local/node/node-latest/node /usr/local/bin/node') \
    .with_unless('test -L /usr/local/bin/node')
  }

  it { should contain_exec('nodejs-download') }
  it { should contain_exec('nodejs-install') }

  describe 'with a given version' do
    let(:params) {{ :version => 'v0.8.0' }}

    it { should contain_exec('nodejs-download-v0.8.0') \
      .with_command('wget http://nodejs.org/dist/v0.8.0/node-v0.8.0.tar.gz') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -f node-v0.8.0.tar.gz')
    }

    it { should contain_exec('nodejs-unpack-v0.8.0') \
      .with_command('tar xzvf node-v0.8.0.tar.gz') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -d node-v0.8.0')
    }

    it { should contain_exec('nodejs-install-v0.8.0') \
      .with_cwd('/usr/local/node/node-v0.8.0') \
      .with_unless('test -f /usr/local/node/node-v0.8.0/node')
    }

    it { should contain_exec('nodejs-symlink-bin-v0.8.0') \
      .with_command('ln -s /usr/local/node/node-v0.8.0/node /usr/local/bin/node') \
      .with_unless('test -L /usr/local/bin/node')
    }
  end

  describe 'with a given target_dir' do
    let(:params) {{ :target_dir => '/bin' }}

    it { should contain_exec('nodejs-symlink-bin-latest') \
      .with_command('ln -s /usr/local/node/node-latest/node /bin/node') \
      .with_unless('test -L /bin/node')
    }
  end

  describe 'without NPM' do
    let(:params) {{ :with_npm => false }}

    it { should_not contain_exec('nodejs-download') }
    it { should_not contain_exec('nodejs-install') }
  end
end
