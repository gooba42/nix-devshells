# Legacy shell.nix for Embedded Rust template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.rustc
    pkgs.cargo
    pkgs.gcc-arm-embedded
    pkgs.openocd
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the Embedded Rust devShell!'
" "";
}
