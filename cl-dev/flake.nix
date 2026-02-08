# flakes/cl-dev/flake.nix — ANSI Common Lisp dev flake
{
  description = "Dev shell and template for ANSI Common Lisp projects (SBCL)";
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
            pkgs.sbcl
            pkgs.quicklisp
            pkgs.parinfer-rust
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
            echo " Common Lisp Nix DevShell (SBCL + Quicklisp)"
            echo "─────────────────────────────────────────────"
            echo "SBCL: $(sbcl --version 2>/dev/null || echo not found)"
            echo "Quicklisp: $(test -d ~/quicklisp && echo installed || echo not installed)"
            echo ""
            echo "Common commands:"
            echo "  sbcl --script src/main.lisp   # Run main"
            echo "  quicklisp (see docs)          # Install libraries"
            echo ""
            echo "See README.md for full usage."
            echo "─────────────────────────────────────────────"
            echo "\033[0m" # reset
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal ANSI Common Lisp project (SBCL + Quicklisp)";
      };
    };
}
