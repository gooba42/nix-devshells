# Legacy shell.nix for Forth template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.gforth
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the Forth devShell!'
" "";
}
