require 'spec_helper'

describe 'nodejs::install', :type => :define do
  let(:title) { 'nodejs::install' }
  let(:facts) {{
    :nodejs_stable_version => 'stable'
  }}

  it { should contain_file('nodejs-install-dir-stable').with_ensure('directory') }

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
    .with_cwd('/usr/local/node/node-stable') \
    .with_unless('test -f /usr/local/node/node-stable/node')
  }

  it { should contain_exec('nodejs-symlink-bin-stable') \
    .with_command('ln -f -s /usr/local/node/node-stable/node /usr/local/bin/node')
  }

  it { should contain_exec('npm-download-stable') }
  it { should contain_exec('npm-install-stable') }
end
