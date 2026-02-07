# Legacy shell.nix for FT232H template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the FT232H devShell!'
" "";
}
