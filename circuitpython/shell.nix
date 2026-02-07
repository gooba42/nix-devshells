# Legacy shell.nix for CircuitPython template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [ pkgs.git ];
  shellHook = "" "
echo 'Welcome to the CircuitPython devShell!'
" "";
}
