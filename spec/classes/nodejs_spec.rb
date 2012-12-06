require 'spec_helper'

describe 'nodejs', :type => :class do
  let(:title) { 'nodejs' }

  it { should contain_exec('node-download') }
  it { should contain_exec('node-unpack') }
  it { should contain_exec('node-install') }
  it { should contain_exec('node-symlink-bin') }

  it { should contain_exec('npm-download') }
  it { should contain_exec('npm-install') }
end
