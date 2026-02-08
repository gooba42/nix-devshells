# flakes/cobol-dev/flake.nix — COBOL dev flake
{
  description = "Dev shell and template for COBOL projects (GnuCOBOL)";
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
            pkgs.gnucobol
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

            echo "\033[1;33m" # yellow bold
            echo "─────────────────────────────────────────────"
            echo " COBOL Nix DevShell (GnuCOBOL)"
            echo "─────────────────────────────────────────────"
            echo "GnuCOBOL: $(cobc --version 2>/dev/null | head -1 || echo not found)"
            echo ""
            echo "Common commands:"
            echo "  make build   # Compile hello.cob"
            echo "  make run     # Run compiled program"
            echo ""
            echo "See README.md for full usage."
            echo "─────────────────────────────────────────────"
            echo "\033[0m" # reset
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal COBOL project (GnuCOBOL)";
      };
    };
}
