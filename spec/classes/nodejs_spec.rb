require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }

  let(:facts) {{
    :kernel         => 'linux',
    :hardwaremodel  => 'x86',
    :osfamily       => 'Debian',
    :processorcount => 2,
  }}

  before(:each) { 
     Puppet::Parser::Functions.newfunction(:evaluate_version, :type => :rvalue) do |args|
       return 'v6.0.1' if args[0] == 'latest'
       return 'v4.4.7' if args[0] == 'lts'
       return 'v5.11.1' if args[0] == '5.11' || args[0] == '5.x'
       return 'v6.7.0' if args[0] == 'v6.7.0'
       return 'v6.4.0' if args[0] == 'v6.4.0'
       return args[0] # simply return default
     end

     Puppet::Parser::Functions.newfunction(:validate_nodejs_version) {
       |args| 'v6.0.1'
     }
   }

  describe 'with default parameters' do
    it { should contain_nodejs__instance('nodejs-lts') \
      .with_version('v4.4.7') \
      .with_target_dir('/usr/local/bin') \
      .with_make_install('false')
    }

    it { should contain_file('/usr/local/node/node-default') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v4.4.7')
    }

    it { should contain_file('/etc/profile.d/nodejs.sh') }
  end

  describe 'with a given version' do
    let(:params) {{
      :version  => 'v5.0.0',
    }}

    it { should contain_nodejs__instance('nodejs-v5.0.0') \
      .with_version('v5.0.0')
    }

    it { should contain_file('/usr/local/node/node-default') \
      .with_ensure('link') \
      .with_target('/usr/local/node/node-v5.0.0')
    }
  end

  describe 'with generic version' do
    let(:params) {{
      :version => '5.11',
    }}

    it { should contain_nodejs__instance('nodejs-5.11') \
      .with_version('v5.11.1') \
      .with_make_install('false') \
    }
  end

  describe 'with latest from major release' do
    let(:params) {{
      :version => '5.x',
    }}

    it { should contain_nodejs__instance('nodejs-5.x') \
      .with_version('v5.11.1') \
      .with_make_install('false') \
    }
  end

  describe 'with latest lts' do
    let(:params) {{
      :version => 'lts',
    }}

    it { should contain_nodejs__instance('nodejs-lts') \
      .with_version('v4.4.7') \
      .with_make_install('false') \
    }
  end

  describe 'with a given target_dir' do
    let(:params) {{
      :target_dir  => '/bin',
    }}

    it { should contain_nodejs__instance('nodejs-lts') \
      .with_target_dir('/bin') \
    }
  end

  describe 'with make_install = true' do
    let(:params) {{
      :make_install => true
    }}

    it { should contain_nodejs__instance('nodejs-lts') \
      .with_make_install('true')
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

  describe 'adds multiple instances from a hash and completes the hash with default values' do
    let(:params) {{
      :instances => {
        "v6.7" => {
          "version" => 'v6.7.0',
        },
        "v6.4" => {
          "version" => 'v6.4.0',
          "make_install" => true,
        }
      }
    }}

    it { should contain_nodejs__instance("nodejs-custom-instance-v6.7.0") \
      .with_version('v6.7.0') \
      .with_ensure('present') \
      .with_target_dir('/usr/local/bin') \
      .with_make_install(false) \
      .with_cpu_cores(2)
    }

    it { should contain_nodejs__instance("nodejs-custom-instance-v6.4.0") \
      .with_version('v6.4.0') \
      .with_ensure('present') \
      .with_target_dir('/usr/local/bin') \
      .with_make_install(true) \
      .with_cpu_cores(2)
    }
  end

  describe 'manages instances to be removed' do
    let(:params) {{
      :instances_to_remove => ['v6.4.0']
    }}

    it { should contain_nodejs__instance("nodejs-uninstall-custom-v6.4.0") \
      .with_ensure("absent") \
      .with_target_dir("/usr/local/bin") \
      .with_make_install(false) \
      .with_cpu_cores(0) \
      .with_version("v6.4.0") \
      .with_target_dir("/usr/local/bin") \
    }
  end

  describe 'it adds multiple instances and declares a default one' do
    let(:params) {{
      :version   => "lts",
      :instances => {
        "node-lts" => {
          "version" => "lts"
        }
      }
    }}

    it { should contain_nodejs__instance("nodejs-custom-instance-v4.4.7") \
      .with_version('v4.4.7') \
      .with_ensure('present') \
      .with_target_dir('/usr/local/bin') \
      .with_make_install(false) \
      .with_cpu_cores(2)
    }

    it { should contain_file("/usr/local/node/node-default") \
      .with_ensure("link") \
      .with_target("/usr/local/node/node-v4.4.7") \
    }

    it { should contain_file("/usr/local/bin/node") \
      .with_ensure("link") \
      .with_target("/usr/local/node/node-default/bin/node")
    }

    it { should contain_file("/usr/local/bin/npm") \
      .with_ensure("link") \
      .with_target("/usr/local/node/node-default/bin/npm")
    }
  end

  describe 'it includes ruby as dependency' do
    let(:params) {{
      :contain_ruby => true,
      :make_install => true,
    }}

    it { should contain_class('nodejs::instance::pkgs') \
      .with_contain_ruby(true) \
      .with_make_install(true) \
    }
  end
end
