require 'spec_helper_acceptance'

describe 'nodejs acceptance test' do
  context 'with default arguments' do
    it 'compiles and applies the catalogue' do
      pp = <<-EOS
        class { '::nodejs': }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
  context 'custom source' do
    it 'applies the catalogue with a manually set source' do
      pp = <<-EOS
        # if a user wants to package something with .tar.xz he needs xz-utils on ubuntu to get
        # it running. This is definetely something out of scope for this module, if someone
        # wants to ship xz compressed tarballs he needs to fix this by himself (.tar.gz
        # works out of the box)
        package { 'xz-utils': } ->
        class { '::nodejs':
          source => "https://nodejs.org/dist/v10.14.2/node-v10.14.2-linux-x64.tar.xz",
        }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
    it 'has proper version installed' do
      rs = shell('node --version')
      expect(rs.stdout).to match /10\.14\.2/
    end
  end
  context 'multiple instances' do
    it 'installs multiple nodejs instances' do
      pp = <<-EOS
        class { '::nodejs':
          version   => "v10.14.2",
          instances => {
            "node-v10.14.2" => {
              version => "v10.14.2"
            },
            "node-v10.13.0" => {
              version => "v10.13.0"
            },
          }
        }
      EOS
      apply_manifest(pp, catch_failures: true)
    end
    it 'has proper version installed' do
      rs = shell('node --version')
      expect(rs.stdout).to match /10\.14\.2/
    end
    it 'has node v10.13.0 installed as well' do
      rs = shell('node-v10.13.0 --version')
      expect(rs.stdout).to match /10\.13\.0/
    end
    it 'drops an instance' do
      pp = <<-EOS
        class { '::nodejs':
          version             => "v10.14.2",
          instances           => {
            "node-v10.14.2" => {
              version => "v10.14.2"
            },
          },
          instances_to_remove => ["v10.13.0"],
        }
      EOS
      apply_manifest(pp, catch_failures: true)
    end
    it 'has v10.13 uninstalled' do
      command_found = true
      begin
        shell('node-v10.13.0 --version')
      rescue Beaker::Host::CommandFailure
        command_found = false
      end

      expect(command_found).to eq false
    end
  end
  context 'multiple instances with sourced instances' do
    it 'installs multiple nodejs instances' do
      pp = <<-EOS
        class { '::nodejs':
          source => "https://nodejs.org/dist/v10.14.2/node-v10.14.2-linux-x64.tar.xz",
          instances => {
            "node-v10.14.2" => {
              source => "https://nodejs.org/dist/v10.14.2/node-v10.14.2-linux-x64.tar.xz",
            },
            "node-v10.13.0" => {
              version => "v10.13.0"
            },
          }
        }
      EOS
      apply_manifest(pp, catch_failures: true)
    end
    it 'has proper version installed' do
      rs = shell('node --version')
      expect(rs.stdout).to match /10\.14\.2/
    end
    it 'drops default instance' do
      pp = <<-EOS
        class { '::nodejs':
          version             => "v10.13.0",
          instances           => {
            "node-v10.13.0" => {
              version => "v10.13.0"
            },
          },
          instances_to_remove => ["v10.14.2"],
        }
      EOS
      apply_manifest(pp, catch_failures: true)
    end
    it 'has v10.14 uninstalled' do
      command_found = true
      begin
        shell('node-v10.14.2 --version')
      rescue Beaker::Host::CommandFailure
        command_found = false
      end

      expect(command_found).to eq false
    end
    it 'has proper version as default' do
      rs = shell('node --version')
      expect(rs.stdout).to match /10\.13\.0/
    end
  end
end
