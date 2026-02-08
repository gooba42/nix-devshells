{
  description = "A Nix-flake-based Arduino/AVR C++ development environment";

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
          description = "Arduino/AVR C++ dev environment with PlatformIO; includes a skeletal project and packaged helper app";
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
              pkgs.platformio
              pkgs.arduino-ide
              pkgs.avrdude
              pkgs.pkgsCross.avr.buildPackages.gcc
              # MicroPython / CircuitPython helpers and common flash tools
              pkgs.esptool
              pkgs.bossa
              pkgs.dfu-util
              pkgs.picotool
              # mpremote isn't packaged in this nixpkgs pin; include pyserial for serial REPL/flash scripts
              pkgs.python3Packages.pyserial
            ];
            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              echo "[arduino-template] Welcome to the Arduino/AVR dev shell!"
              echo "Tools: arduino-ide, platformio, avrdude, avr-gcc, esptool, bossa, dfu-util, picotool, pyserial"
              echo "Run 'arduino-ide' to launch the IDE, 'platformio run' to build, or 'nix run .#flash' to flash your board."
            '';
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs, ... }:
        {
          default = pkgs.writeShellScriptBin "dev-helper" ''
            echo "Arduino/AVR dev environment"
            command -v platformio >/dev/null 2>&1 && platformio --version || true
            command -v avrdude >/dev/null 2>&1 && avrdude -? | head -n1 || true
            echo "This binary is built by Nix (packages.default)."
          '';

          flash = pkgs.writeShellScriptBin "flash-arduino" ''
            #!/usr/bin/env bash
            set -euo pipefail
            ENV_NAME="''${ENV_NAME:-uno}"
            PORT="''${PORT:-/dev/ttyACM0}"
            if [ ! -f platformio.ini ]; then
              echo "platformio.ini not found; run from project root" >&2
              exit 1
            fi
            echo "Flashing Arduino project (env=$ENV_NAME port=$PORT) via PlatformIO..."
            exec ${pkgs.platformio}/bin/platformio run --environment "$ENV_NAME" --target upload --upload-port "$PORT"
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
          flash = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.flash;
          };
        }
      );
    };
}
