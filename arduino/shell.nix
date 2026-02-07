{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.platformio
    pkgs.avrdude
    pkgs.gcc
    pkgs.python3
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for Arduino/AVR dev. Use 'nix develop' for full flake support."
  '';
}
