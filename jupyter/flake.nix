{
  description = "A Nix-flake-based Jupyter development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import inputs.nixpkgs { inherit system; };
            # Simple Python env for Jupyter
            python = pkgs.python3;
            pythonPkgs =
              ps: with ps; [
                ipykernel
                jupyterlab
              ];
            pythonEnv = python.withPackages pythonPkgs;
          in
          f {
            inherit pkgs;
            inherit pythonEnv;
          }
        );
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "Jupyter/Python dev environment; includes ipykernel and packaged helper app";
        };
      };

      devShells = forEachSupportedSystem (
        {
          pkgs,
          pythonEnv,
        }:
        {
          default = pkgs.mkShellNoCC {
            venvDir = ".venv";
            packages = [
              pythonEnv
              pkgs.poetry
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
        }
      );

      packages = forEachSupportedSystem (
        {
          pkgs,
          pythonEnv,
        }:
        {
          default = pkgs.writeShellScriptBin "dev-helper" ''
            echo "Jupyter dev environment"
            ${pythonEnv}/bin/python --version
            ${pythonEnv}/bin/jupyter --version
            echo "This binary is built by Nix (packages.default)."
          '';
        }
      );

      apps = forEachSupportedSystem (
        { pkgs }:
        {
          default = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
        }
      );
    };
}
