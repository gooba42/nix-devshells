# Legacy shell.nix for Erlang template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.erlang
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the Erlang devShell!'
" "";
}
