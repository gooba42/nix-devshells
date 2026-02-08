# flakes/ada-dev/flake.nix — Ada dev flake
{
  description = "Dev shell and template for Ada projects (GNAT)";
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
            pkgs.gnat
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

            echo "[ada-dev-template] Welcome to the Ada dev shell!"
            echo "Tools: gnat, gprbuild, alejandra, statix, deadnix, git"
            echo "Run 'make build' to build, or 'make run' to run the example. See README.md for usage."
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal Ada project (GNAT)";
      };
    };
}
