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
end
