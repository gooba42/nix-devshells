# Legacy shell.nix for Common Lisp template
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.sbcl
    pkgs.git
  ];
  shellHook = "" "
echo 'Welcome to the Common Lisp devShell!'
" "";
}
