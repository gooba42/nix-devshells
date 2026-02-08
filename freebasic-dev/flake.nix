# flakes/freebasic-dev/flake.nix — FreeBASIC dev flake
{
  description = "Dev shell and template for FreeBASIC projects";
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
            pkgs.freebasic
            pkgs.treefmt
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

            echo "\033[1;34m" # blue bold
            echo "─────────────────────────────────────────────"
            echo " FreeBASIC Nix DevShell"
            echo "─────────────────────────────────────────────"
            echo "FreeBASIC: $(fbc --version 2>&1 | head -1 || echo not found)"
            echo ""
            echo "Common commands:"
            echo "  make build   # Compile hello.bas"
            echo "  make run     # Run hello"
            echo ""
            echo "See README.md for full usage."
            echo "─────────────────────────────────────────────"
            echo "\033[0m" # reset
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal FreeBASIC project";
      };
    };
}
