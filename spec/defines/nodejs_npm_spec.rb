require 'spec_helper'

describe 'nodejs::npm', :type => :define do
  let(:title) { 'nodejs::npm' }
  let(:facts) {{
    :nodejs_stable_version => 'v0.10.20'
  }}

  describe 'install npm package' do
    let (:params) {{
      :name => '/foo:yo',    }}

    it { should contain_exec('npm_install_/foo:yo') \
      .with_command('npm install  yo') \
      .with_unless("npm list -p -l | grep '/foo/node_modules/yo:yo'")
    }
  end

  describe 'uninstall npm package' do
    let (:params) {{
      :name   => '/foo:yo',
      :ensure => 'absent'
    }}

    it { should contain_exec('npm_remove_/foo:yo') \
      .with_command('npm remove yo') \
      .with_onlyif("npm list -p -l | grep '/foo/node_modules/yo:yo'")
    }
  end

  describe 'install npm package with version' do
    let (:params) {{
      :name    => '/foo:yo',
      :version => '1.4'
    }}

    it { should contain_exec('npm_install_/foo:yo') \
      .with_command('npm install  yo@1.4') \
      .with_unless("npm list -p -l | grep '/foo/node_modules/yo:yo@1.4'")
    }
  end

  describe 'install package globally from source' do
    let (:params) {{
      :name        => '/foo:source',
      :version     => '1.4',
      :source      => 'source',
      :install_opt => '-g'
    }}

    it { should contain_exec('npm_install_/foo:source') \
      .with_command('npm install -g source') \
      .with_unless("npm list -p -l | grep '/foo/node_modules/source:source@1.4'")
    }
  end

  describe 'home path for unix systems' do
    operating_systems = ['Debian', 'Ubuntu', 'RedHat', 'SLES', 'Fedora', 'CentOS']
    operating_systems.each do |os|
      let (:params) {{
        :name         => '/foo:yo',
        :exec_as_user => 'Ma27'
      }}
      let(:facts) {{
        :operatingsystem       => os,
        :nodejs_stable_version => 'v0.10.20'
      }}

      it { should contain_exec('npm_install_/foo:yo') \
        .with_command('npm install  yo') \
        .with_unless("npm list -p -l | grep '/foo/node_modules/yo:yo'") \
        .with_environment('HOME=/home/Ma27')
      }
    end
  end
end
