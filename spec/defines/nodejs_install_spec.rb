require 'spec_helper'

describe 'nodejs::install', :type => :define do
  let(:title) { 'nodejs::install' }

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
end
