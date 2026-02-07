# Legacy shell.nix for COBOL template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.gcc
    pkgs.gcc-cobol
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the COBOL devShell!'
" "";
}
