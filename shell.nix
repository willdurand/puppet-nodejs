with import <nixpkgs> { };

mkShell {
  name = "puppet-dev-shell";
  buildInputs = [
    ruby bundler rubocop
  ];

  shellHook = ''
    export PUPPET_INSTALL_TYPE=agent
    export BEAKER_setfile=spec/acceptance/nodesets/ubuntu-1604-x64.yml
    export BEAKER_PUPPET_COLLECTION=puppet6
  '';
}
