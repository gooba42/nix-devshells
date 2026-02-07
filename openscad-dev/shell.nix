# flakes/openscad-dev/shell.nix — Legacy shell for non-flake users
# Purpose:
#   Provides backward compatibility for users not using flakes.
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = [
    pkgs.openscad
    pkgs.meshlab
    pkgs.openscad-lsp
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for OpenSCAD dev. Use 'nix develop' for full flake support."
  '';
}
