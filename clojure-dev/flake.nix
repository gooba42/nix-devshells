# flakes/clojure-dev/flake.nix — Clojure dev flake
{
  description = "Dev shell and template for Clojure projects (Clojure CLI + Leiningen)";
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
            pkgs.clojure
            pkgs.leiningen
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

            echo "\033[1;32m" # green bold
            echo "─────────────────────────────────────────────"
            echo " Clojure Nix DevShell (Clojure CLI + Leiningen)"
            echo "─────────────────────────────────────────────"
            echo "Clojure: $(clojure --version 2>/dev/null || echo not found)"
            echo "Leiningen: $(lein --version 2>/dev/null | head -1 || echo not found)"
            echo ""
            echo "Common commands:"
            echo "  clojure -M -m main   # Run main"
            echo "  lein repl            # Start REPL"
            echo ""
            echo "See README.md for full usage."
            echo "─────────────────────────────────────────────"
            echo "\033[0m" # reset
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal Clojure project (Clojure CLI + Leiningen)";
      };
    };
}
