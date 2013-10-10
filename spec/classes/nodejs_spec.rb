require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }
  let(:facts) {{
    :nodejs_stable_version => 'v0.10.20'
  }}

  it { should contain_file('nodejs-install-dir-v0.10.20') \
    .with_ensure('directory') \
    .with_path('/usr/local/node')
  }

  it { should contain_wget__fetch('nodejs-download-v0.10.20') \
    .with_source('http://nodejs.org/dist/v0.10.20/node-v0.10.20.tar.gz') \
    .with_destination('/usr/local/node/node-v0.10.20.tar.gz')
  }

  it { should contain_file('nodejs-check-tar-v0.10.20') \
    .with_ensure('file') \
    .with_path('/usr/local/node/node-v0.10.20.tar.gz')
  }

  it { should contain_exec('nodejs-unpack-v0.10.20') \
    .with_command('tar xzvf node-v0.10.20.tar.gz') \
    .with_cwd('/usr/local/node') \
    .with_unless('test -d /usr/local/node/node-v0.10.20')
  }

  it { should contain_file('nodejs-check-unpack-v0.10.20') \
    .with_ensure('directory') \
    .with_path('/usr/local/node/node-v0.10.20')
  }

  it { should contain_exec('nodejs-make-install-v0.10.20') \
    .with_command('./configure && make && make install') \
    .with_path('/usr/local/node/node-v0.10.20:/usr/bin:/bin:/usr/sbin:/sbin') \
    .with_cwd('/usr/local/node/node-v0.10.20') \
    .with_unless('test -f /usr/local/node/node-v0.10.20/node')
  }

  it { should contain_file('nodejs-symlink-bin-v0.10.20') \
    .with_ensure('link') \
    .with_path('/usr/local/bin/node') \
    .with_target('/usr/local/node/node-v0.10.20/node')
  }

  it { should contain_file('nodejs-symlink-bin-with-version-v0.10.20') \
    .with_ensure('link') \
    .with_path('/usr/local/bin/node-v0.10.20') \
    .with_target('/usr/local/node/node-v0.10.20/node')
  }

  it { should_not contain_wget__fetch('npm-download-v0.10.20') }
  it { should_not contain_exec('npm-install-v0.10.20') }

  describe 'with a given version' do
    let(:params) {{ :version => 'v0.8.0' }}

    it { should contain_wget__fetch('nodejs-download-v0.8.0') \
      .with_source('http://nodejs.org/dist/v0.8.0/node-v0.8.0.tar.gz') \
      .with_destination('/usr/local/node/node-v0.8.0.tar.gz')
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

    it { should contain_file('nodejs-symlink-bin-v0.8.0') \
      .with_ensure('link') \
      .with_path('/usr/local/bin/node') \
      .with_target('/usr/local/node/node-v0.8.0/node')
    }

    it { should contain_file('nodejs-symlink-bin-with-version-v0.8.0') \
      .with_ensure('link') \
      .with_path('/usr/local/bin/node-v0.8.0') \
      .with_target('/usr/local/node/node-v0.8.0/node')
    }

    it { should_not contain_wget__fetch('npm-download-v0.8.0') }
    it { should_not contain_exec('npm-install-v0.8.0') }
  end

  describe 'with a given target_dir' do
    let(:params) {{ :target_dir => '/bin' }}

    it { should contain_file('nodejs-symlink-bin-v0.10.20') \
      .with_ensure('link') \
      .with_path('/bin/node') \
      .with_target('/usr/local/node/node-v0.10.20/node')
    }
  end

  describe 'without NPM' do
    let(:params) {{ :with_npm => false }}

    it { should_not contain_exec('npm-download-v0.10.20') }
    it { should_not contain_exec('npm-install-v0.10.20') }
  end

  describe 'with make_install = false' do
    let(:params) {{ :make_install => false }}

    it { should_not contain_exec('nodejs-make-install-v0.10.20') }
  end
end
