{
  description = "A Nix-flake-based Python development environment with venv, pip, and optional reusable devShell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
            # Helper to get python by version string like "3.11"
            concatMajorMinor =
              v:
              pkgs.lib.pipe v [
                pkgs.lib.versions.splitVersion
                (pkgs.lib.sublist 0 2)
                pkgs.lib.concatStrings
              ];
            python = pkgs."python${concatMajorMinor version}";
          in
          f {
            inherit pkgs python;
          }
        );

      # Change this value to update the Python version (major.minor)
      version = "3.11";
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "Python dev environment with venv + direnv; includes a skeletal src/ app and packaged helper app";
        };
      };

      # Reusable Python devShell function for importing into other flakes
      # Usage: (import /path/to/python-flake).mkPythonShell { inherit pkgs; pythonVersion = "3.11"; }
      mkPythonShell =
        {
          pkgs,
          pythonVersion ? "3.11",
        }:
        let
          concatMajorMinor =
            v:
            pkgs.lib.pipe v [
              pkgs.lib.versions.splitVersion
              (pkgs.lib.sublist 0 2)
              pkgs.lib.concatStrings
            ];
          python = pkgs."python${concatMajorMinor pythonVersion}";
        in
        pkgs.mkShell {
          venvDir = ".venv";
          packages = with python.pkgs; [
            venvShellHook
            pip
          ];
        };

      devShells = forEachSupportedSystem (
        {
          pkgs,
          python,
        }:
        {
          default = pkgs.mkShell {
            venvDir = ".venv";
            postShellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

                              venvVersionWarn() {
                                local venvVersion
                                venvVersion="$venvDir/bin/python" -c 'import platform; print(platform.python_version())')"
                                [[ "$venvVersion" == "${python.version}" ]] && return
                                cat <<EOF
                Warning: Python version mismatch: [$venvVersion (venv)] != [${python.version}]
                         Delete '$venvDir' and reload to rebuild for version ${python.version}
                EOF
                              }
                              venvVersionWarn
              echo "[python-template] Welcome to the Python dev shell!"
              echo "Python: ${python.version} | venv: .venv | pip available"
              echo "Run 'python -m venv .venv && source .venv/bin/activate' if not already activated."
              echo "See README.md for usage."
            '';
            packages =
              with python.pkgs;
              [
                venvShellHook
                pip
              ]
              ++ [ pkgs.git ];
          };
        }
      );
      packages = forEachSupportedSystem (
        {
          pkgs,
          python,
        }:
        {
          # Build the skeletal project as a proper Python package
          default = python.pkgs.buildPythonApplication {
            pname = "sample-python-app";
            version = "0.1.0";
            src = ./.;
            format = "pyproject";
            # Ensure build backend is present
            nativeBuildInputs = with python.pkgs; [
              setuptools
              wheel
            ];
            propagatedBuildInputs = [ ];
            pythonImportsCheck = [ "app" ];
            meta.mainProgram = "app";
          };

          # Optional helper for quick diagnostics
          devHelper = pkgs.writeShellScriptBin "dev-helper" ''
            echo "Python ${python.version} development environment"
            command -v python >/dev/null 2>&1 && python --version || true
            command -v pip >/dev/null 2>&1 && pip --version || true
            echo "Virtual env dir: .venv (created on first direnv activation)"
            echo "This binary is built by Nix (packages.default)."
          '';
        }
      );

      apps = forEachSupportedSystem (
        {
          pkgs,
        }:
        {
          default = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
          dev-helper = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.devHelper;
          };
        }
      );
    };
}
