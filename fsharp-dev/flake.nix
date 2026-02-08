# flakes/fsharp-dev/flake.nix — F# dev flake
{
  description = "Dev shell and template for F# projects (dotnet SDK)";
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
            pkgs.dotnet-sdk
            pkgs.fantomas
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
            pkgs.gnumake
          ];
          shellHook = ''
            # Initialize git repository if not already present
            if [ ! -d .git ]; then
              git init
              echo "✓ Initialized git repository"
            fi

            echo "\033[1;35m" # magenta bold
            echo "─────────────────────────────────────────────"
            echo " F# Nix DevShell (dotnet SDK)"
            echo "─────────────────────────────────────────────"
            echo "dotnet: $(dotnet --version 2>/dev/null || echo not found)"
            echo ""
            echo "Common commands:"
            echo "  make build   # Build project"
            echo "  make run     # Run project"
            echo ""
            echo "See README.md for full usage."
            echo "─────────────────────────────────────────────"
            echo "\033[0m" # reset
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal F# project (dotnet SDK)";
      };
    };
}
