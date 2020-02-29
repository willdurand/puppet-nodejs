require 'spec_helper'

describe 'nodejs::source_filename' do
  it { should run.with_params('http://myrepo.foo.bar:6000/local_repo/node/node-v10.14.1-linux-x64.tar.xz').and_return('node-v10.14.1-linux-x64.tar.xz') }
end
