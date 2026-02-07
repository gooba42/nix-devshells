# Legacy shell.nix for FreeBASIC template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.freebasic
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the FreeBASIC devShell!'
" "";
}
