require 'spec_helper'

describe 'nodejs::install', :type => :define do
  let(:title) { 'nodejs::install' }
  let(:facts) {{
    :nodejs_stable_version => 'v0.10.20'
  }}

  it { should contain_file('nodejs-install-dir-v0.10.20').with_ensure('directory') }

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
    .with_cwd('/usr/local/node/node-v0.10.20') \
    .with_unless('test -f /usr/local/node/node-v0.10.20/node')
  }

  it { should contain_file('nodejs-symlink-bin-v0.10.20') \
    .with_ensure('link') \
    .with_path('/usr/local/bin/node') \
    .with_target('/usr/local/node/node-v0.10.20/node')
  }

  it { should_not contain_wget__fetch('npm-download-v0.10.20') }
  it { should_not contain_exec('npm-install-v0.10.20') }
end
