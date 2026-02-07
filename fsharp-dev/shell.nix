# Legacy shell.nix for F# template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.dotnet-sdk
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the F# devShell!'
" "";
}
