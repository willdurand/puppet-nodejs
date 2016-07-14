require 'spec_helper'

describe 'nodejs::install', :type => :define do
  let(:title) { 'nodejs::install' }
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
        |args| 'v6.2.0'
    }
    Puppet::Parser::Functions.newfunction(:validate_nodejs_version) {
        |args| 'v6.2.0'
    }
  }

  describe 'with default parameters' do
    
    let(:params) {{ }}

    it { should contain_file('nodejs-install-dir') \
      .with_ensure('directory')
    }

    it { should contain_nodejs__install__download('nodejs-download-v6.0.0') \
      .with_source('https://nodejs.org/dist/v6.0.0/node-v6.0.0.tar.gz') \
      .with_destination('/usr/local/node/node-v6.0.0.tar.gz')
    }

    it { should contain_file('nodejs-check-tar-v6.0.0') \
      .with_ensure('file') \
      .with_path('/usr/local/node/node-v6.0.0.tar.gz')
    }

    it { should contain_exec('nodejs-unpack-v6.0.0') \
      .with_command('tar -xzvf node-v6.0.0.tar.gz -C /usr/local/node/node-v6.0.0 --strip-components=1') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -f /usr/local/node/node-v6.0.0/bin/node')
    }

    it { should contain_file('/usr/local/node/node-v6.0.0') \
      .with_ensure('directory')
    }

    it { should contain_exec('nodejs-make-install-v6.0.0') \
      .with_command('./configure --prefix=/usr/local/node/node-v6.0.0 && make -j 2 && make -j 2 install') \
      .with_cwd('/usr/local/node/node-v6.0.0') \
      .with_unless('test -f /usr/local/node/node-v6.0.0/bin/node')
    }

    it { should contain_file('nodejs-symlink-bin-with-version-v6.0.0') \
      .with_ensure('link') \
      .with_path('/usr/local/bin/node-v6.0.0') \
      .with_target('/usr/local/node/node-v6.0.0/bin/node')
    }

    it { should contain_file('npm-symlink-bin-with-version-v6.0.0') \
      .with_ensure('file') \
      .with_mode('0755') \
      .with_path('/usr/local/bin/npm-v6.0.0') \
      .with_content(/(.*)\/usr\/local\/bin\/node-v6.0.0 \/usr\/local\/node\/node-v6.0.0\/bin\/npm "\$@"/)
    }

    it { should_not contain_file('/usr/local/bin/node') }
    it { should_not contain_file('/usr/local/bin/npm') }

    it { should_not contain_nodejs__install__download('npm-download-v6.0.0') }
    it { should_not contain_exec('npm-install-v6.0.0') }
  end

  describe 'default parameters with cpu_cores set manually to 1' do

    let(:params) {{
      :cpu_cores => 1
    }}

    it { should contain_exec('nodejs-make-install-v6.0.0') \
      .with_command('./configure --prefix=/usr/local/node/node-v6.0.0 && make -j 1 && make -j 1 install') \
      .with_cwd('/usr/local/node/node-v6.0.0') \
      .with_unless('test -f /usr/local/node/node-v6.0.0/bin/node')
    }
  end

  describe 'with specific version v6.0.0' do

    let(:params) {{
      :version => 'v6.0.0'
    }}

    it { should contain_file('nodejs-install-dir') \
      .with_ensure('directory')
    }

    it { should contain_nodejs__install__download('nodejs-download-v6.0.0') \
      .with_source('https://nodejs.org/dist/v6.0.0/node-v6.0.0.tar.gz') \
      .with_destination('/usr/local/node/node-v6.0.0.tar.gz')
    }

    it { should contain_file('nodejs-check-tar-v6.0.0') \
      .with_ensure('file') \
      .with_path('/usr/local/node/node-v6.0.0.tar.gz')
    }

    it { should contain_exec('nodejs-unpack-v6.0.0') \
      .with_command('tar -xzvf node-v6.0.0.tar.gz -C /usr/local/node/node-v6.0.0 --strip-components=1') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -f /usr/local/node/node-v6.0.0/bin/node')
    }

    it { should contain_file('/usr/local/node/node-v6.0.0') \
      .with_ensure('directory')
    }

    it { should contain_exec('nodejs-make-install-v6.0.0') \
      .with_command('./configure --prefix=/usr/local/node/node-v6.0.0 && make -j 2 && make -j 2 install') \
      .with_cwd('/usr/local/node/node-v6.0.0') \
      .with_unless('test -f /usr/local/node/node-v6.0.0/bin/node')
    }

    it { should contain_file('nodejs-symlink-bin-with-version-v6.0.0') \
      .with_ensure('link') \
      .with_path('/usr/local/bin/node-v6.0.0') \
      .with_target('/usr/local/node/node-v6.0.0/bin/node')
    }

    it { should contain_file('npm-symlink-bin-with-version-v6.0.0') \
      .with_ensure('file') \
      .with_mode('0755') \
      .with_path('/usr/local/bin/npm-v6.0.0') \
      .with_content(/(.*)\/usr\/local\/bin\/node-v6.0.0 \/usr\/local\/node\/node-v6.0.0\/bin\/npm "\$@"/)
    }

    it { should_not contain_file('/usr/local/bin/node') }
    it { should_not contain_file('/usr/local/bin/npm') }

    it { should_not contain_nodejs__install__download('npm-download-v6.0.0') }
    it { should_not contain_exec('npm-install-v6.0.0') }
  end

  describe 'specific version v6.0.0 and cpu_cores manually set to 1' do

    let(:params) {{
      :version   => 'v6.0.0',
      :cpu_cores => 1,
    }}

    it { should contain_exec('nodejs-make-install-v6.0.0') \
      .with_command('./configure --prefix=/usr/local/node/node-v6.0.0 && make -j 1 && make -j 1 install') \
      .with_cwd('/usr/local/node/node-v6.0.0') \
      .with_unless('test -f /usr/local/node/node-v6.0.0/bin/node')
    }
  end

  describe 'with a given target_dir' do
    let(:params) {{
      :target_dir => '/bin'
    }}

    it { should contain_file('nodejs-symlink-bin-with-version-v6.0.0') \
      .with_ensure('link') \
      .with_path('/bin/node-v6.0.0') \
      .with_target('/usr/local/node/node-v6.0.0/bin/node')
    }
  end

  describe 'with make_install = false' do
    let(:params) {{
      :make_install => false
    }}

    it { should_not contain_exec('nodejs-make-install-v6.0.0') }
  end

  describe 'on a RedHat based OS (osfamily = RedHat)' do
    let(:facts) {{
      :osfamily       => 'RedHat',
      :kernel         => 'linux',
      :hardwaremodel  => 'x86',
      :processorcount => 2,
    }}
    let(:params) {{
      :version => 'v6.0.0'
    }}

    it { should contain_package('gcc-c++').with( 
      :ensure => 'present'
    )} 
  end

  describe 'on a OpenSuse based OS (osfamily = Suse)' do
    let(:facts) {{
      :osfamily       => 'Suse',
      :kernel         => 'linux',
      :hardwaremodel  => 'x86',
      :processorcount => 2,
    }}
    let(:params) {{
      :version => 'v6.0.0'
    }}

    it { should contain_package('gcc-c++').with(
      :ensure => 'present'
    )}
  end

  describe 'on a Non-RedHat based OS (osfamily != RedHat)' do
    let(:facts) {{
      :osfamily       => 'Debian',
      :kernel         => 'linux',
      :hardwaremodel  => 'x86',
      :processorcount => 2,
    }}
    let(:params) {{
      :version => 'v6.0.0'
    }}

    it { should contain_package('g++').with(
      :ensure => 'present'
    )}
  end

  describe 'uninstall' do
    describe 'any instance' do
      let(:params) {{
        :version => 'v0.12',
        :ensure  => 'absent',
      }}
      let(:facts) {{
        :nodejs_installed_version => 'v0.12',
        :processorcount           => 2,
      }}

      it { should contain_file('/usr/local/node/node-v0.12') \
        .with(:ensure => 'absent', :force => true, :recurse => true) \
      }

      it { should contain_file('/usr/local/bin/node-v0.12') \
        .with_ensure('absent') \
      }
    end

    describe 'default instance' do
      let(:facts) {{
        :nodejs_installed_version => 'v5.6.0',
        :processorcount           => 2,
      }}
      let(:params) {{
        :version => 'v5.6.0',
        :ensure  => 'absent',
      }}

      it { should contain_file('/usr/local/node/node-v5.6.0') \
        .with_ensure('absent') \
      }

      it { should contain_file('/usr/local/node/node-default') \
        .with_ensure('absent') \
      }

      it { should contain_file('/usr/local/bin/node-v5.6.0') \
        .with_ensure('absent') \
      }
    end
  end
end
