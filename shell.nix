# Legacy shell.nix for non-flake users
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.curl
    pkgs.gcc
    pkgs.cmake
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for Nix flakes. Use 'nix develop' for full flake support."
  '';
}
