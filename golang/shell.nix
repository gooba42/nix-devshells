{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.go
    pkgs.gotools
    pkgs.golangci-lint
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for Go dev. Use 'nix develop' for full flake support."
  '';
}
