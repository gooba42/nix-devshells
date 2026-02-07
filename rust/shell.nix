{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.rustc
    pkgs.cargo
    pkgs.rustfmt
    pkgs.clippy
    pkgs.rust-analyzer
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for Rust dev. Use 'nix develop' for full flake support."
  '';
}
