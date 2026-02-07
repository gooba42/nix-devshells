# Legacy shell.nix for Clojure template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.clojure
    pkgs.openjdk
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the Clojure devShell!'
" "";
}
