{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.gnat
    pkgs.gprbuild
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for Ada dev. Use 'nix develop' for full flake support."
  '';
}
