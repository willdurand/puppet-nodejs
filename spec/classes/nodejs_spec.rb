require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }
  let(:facts) {{
    :nodejs_stable_version => 'stable'
  }}

  it { should contain_file('nodejs-install-dir-stable') \
    .with_ensure('directory') \
    .with_path('/usr/local/node')
  }

  it { should contain_exec('nodejs-download-stable') \
    .with_command('wget http://nodejs.org/dist/stable/node-stable.tar.gz') \
    .with_cwd('/usr/local/node') \
    .with_unless('test -f node-stable.tar.gz')
  }

  it { should contain_file('nodejs-check-tar-stable') \
    .with_ensure('file') \
    .with_path('/usr/local/node/node-stable.tar.gz')
  }

  it { should contain_exec('nodejs-unpack-stable') \
    .with_command('tar xzvf node-stable.tar.gz') \
    .with_cwd('/usr/local/node') \
    .with_unless('test -d /usr/local/node/node-stable')
  }

  it { should contain_file('nodejs-check-unpack-stable') \
    .with_ensure('directory') \
    .with_path('/usr/local/node/node-stable')
  }

  it { should contain_exec('nodejs-make-install-stable') \
    .with_command('python configure && make install') \
    .with_cwd('/usr/local/node/node-stable') \
    .with_unless('test -f /usr/local/node/node-stable/node')
  }

  it { should contain_exec('nodejs-symlink-bin-stable') \
    .with_command('ln -f -s /usr/local/node/node-stable/node /usr/local/bin/node')
  }

  it { should contain_file('nodejs-check-symlink-stable') \
    .with_ensure('link') \
    .with_path('/usr/local/bin/node') \
    .with_target('/usr/local/node/node-stable/node')
  }

  it { should contain_exec('nodejs-symlink-bin-with-version-stable') \
    .with_command('ln -f -s /usr/local/node/node-stable/node /usr/local/bin/node-stable')
  }

  it { should contain_exec('npm-download-stable') }
  it { should contain_exec('npm-install-stable') }

  describe 'with a given version' do
    let(:params) {{ :version => 'v0.8.0' }}

    it { should contain_exec('nodejs-download-v0.8.0') \
      .with_command('wget http://nodejs.org/dist/v0.8.0/node-v0.8.0.tar.gz') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -f node-v0.8.0.tar.gz')
    }

    it { should contain_file('nodejs-check-tar-v0.8.0') \
      .with_ensure('file') \
      .with_path('/usr/local/node/node-v0.8.0.tar.gz')
    }

    it { should contain_exec('nodejs-unpack-v0.8.0') \
      .with_command('tar xzvf node-v0.8.0.tar.gz') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -d /usr/local/node/node-v0.8.0')
    }

    it { should contain_file('nodejs-check-unpack-v0.8.0') \
      .with_ensure('directory') \
      .with_path('/usr/local/node/node-v0.8.0')
    }

    it { should contain_exec('nodejs-make-install-v0.8.0') \
      .with_cwd('/usr/local/node/node-v0.8.0') \
      .with_unless('test -f /usr/local/node/node-v0.8.0/node')
    }

    it { should contain_exec('nodejs-symlink-bin-v0.8.0') \
      .with_command('ln -f -s /usr/local/node/node-v0.8.0/node /usr/local/bin/node')
    }

    it { should contain_file('nodejs-check-symlink-v0.8.0') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v0.8.0/node') \
      .with_path('/usr/local/bin/node')
    }

    it { should contain_exec('nodejs-symlink-bin-with-version-v0.8.0') \
      .with_command('ln -f -s /usr/local/node/node-v0.8.0/node /usr/local/bin/node-v0.8.0')
    }

    it { should contain_exec('npm-download-v0.8.0') }
    it { should contain_exec('npm-install-v0.8.0') }
  end

  describe 'with a given target_dir' do
    let(:params) {{ :target_dir => '/bin' }}

    it { should contain_exec('nodejs-symlink-bin-stable') \
      .with_command('ln -f -s /usr/local/node/node-stable/node /bin/node')
    }
  end

  describe 'without NPM' do
    let(:params) {{ :with_npm => false }}

    it { should_not contain_exec('npm-download-stable') }
    it { should_not contain_exec('npm-install-stable') }
  end

  describe 'with make_install = false' do
    let(:params) {{ :make_install => false }}

    it { should_not contain_exec('nodejs-make-install-stable') }
  end
end
