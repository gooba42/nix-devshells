{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ self, ... }:
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
            # Shared C++ development packages (inlined from cpp-devshell for self-containment)
            cppDevShellPkgs =
              with pkgs;
              [
                clang
                clang-tools
                cmake
                codespell
                conan
                cppcheck
                doxygen
                gtest
                lcov
              ]
              ++ (if stdenv.isDarwin then [ ] else [ gdb ]);
          in
          f {
            inherit pkgs;
            inherit cppDevShellPkgs;
          }
        );
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "C/C++ dev environment; includes a skeletal project and packaged helper app";
        };
      };

      devShells = forEachSupportedSystem (
        {
          pkgs,
          cppDevShellPkgs,
        }:
        {
          default = pkgs.mkShell {
            packages = cppDevShellPkgs ++ [
              pkgs.git
              pkgs.gnumake
            ];
            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              echo "[c-template] Welcome to the C/C++ dev shell!"
              echo "Available: clang, cmake, codespell, conan, cppcheck, doxygen, gtest, lcov, gdb (if not Darwin)"
              echo "Run 'make' to build the example, or 'nix run .#dev-helper' for a tool summary."
            '';
          };
        }
      );
      packages = forEachSupportedSystem (
        { pkgs, ... }:
        {
          # Build the skeletal C app via the provided Makefile
          default = pkgs.stdenv.mkDerivation {
            pname = "sample-c-app";
            version = "0.1.0";
            src = ./.;
            buildInputs = [ pkgs.gcc ];
            buildPhase = "make";
            installPhase = ''
              mkdir -p $out/bin
              cp build/main $out/bin/sample-c-app
            '';
            meta.mainProgram = "sample-c-app";
          };

          dev-helper = pkgs.writeShellScriptBin "dev-helper" ''
            echo "C/C++ dev environment"
            command -v gcc >/dev/null 2>&1 && gcc --version | head -n1 || true
            command -v clang >/dev/null 2>&1 && clang --version | head -n1 || true
            echo "This binary is built by Nix (packages.dev-helper)."
          '';
        }
      );

      apps = forEachSupportedSystem (
        { pkgs, ... }:
        {
          default = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
          dev-helper = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.dev-helper;
          };
        }
      );
    };
}
