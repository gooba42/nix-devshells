# Legacy shell.nix for C++ template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.gcc
    pkgs.cmake
    pkgs.gdb
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the C++ devShell!'
" "";
}
