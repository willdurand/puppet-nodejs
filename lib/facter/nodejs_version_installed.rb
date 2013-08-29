Facter.add("nodejs_version_installed") do
  setcode do
    Facter::Util::Resolution.exec('node -v 2> /dev/null')
  end
end
