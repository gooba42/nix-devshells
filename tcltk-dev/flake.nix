# flakes/tcltk-dev/flake.nix — Tcl/Tk dev flake
{
  description = "Dev shell and template for Tcl/Tk projects";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        pkgs.mkShell {
            buildInputs = [
              pkgs.tcl
              pkgs.tk
              pkgs.nix
              pkgs.alejandra
              pkgs.statix
              pkgs.deadnix
              pkgs.nix-init
              pkgs.nix-update
              pkgs.nix-output-monitor
              pkgs.nix-tree
              pkgs.nvd
              pkgs.git
            ];
          ];
        };
      templates.default = {
        path = ./template;
        description = "Minimal Tcl/Tk project";
      };
    };
}
