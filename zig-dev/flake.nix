# flakes/zig-dev/flake.nix — Zig dev flake
{
  description = "Dev shell and template for Zig projects";
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
            pkgs.zig
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
          shellHook = ''
            # Initialize git repository if not already present
            if [ ! -d .git ]; then
              git init
              echo "✓ Initialized git repository"
            fi
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal Zig project";
      };
    };
}
