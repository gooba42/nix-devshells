# Legacy shell.nix for .NET template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.dotnet-sdk
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the .NET devShell!'
" "";
}
