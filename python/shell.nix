{pkgs ? import <nixpkgs> {}}: let
  pythonEnv = pkgs.python3.withPackages (_ps: []);
in
  pkgs.mkShell {
    packages = [
      pythonEnv
    ];
  }
