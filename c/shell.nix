{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.gcc
    pkgs.cmake
    pkgs.clang
    pkgs.gdb
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for C/C++ dev. Use 'nix develop' for full flake support."
  '';
}
