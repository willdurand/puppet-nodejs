with import <nixpkgs> { };

mkShell {
  name = "puppet-dev-shell";
  buildInputs = [
    ruby bundler rubocop
  ];
}
