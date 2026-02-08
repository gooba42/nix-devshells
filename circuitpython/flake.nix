{
  description = "A Nix-flake-based CircuitPython development environment for RP2040, ESP32-S2/S3, SAMD, nRF52, and STM32 boards";

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

      # CircuitPython typically uses Python 3.11+
      version = "3.11";
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "CircuitPython dev environment for RP2040, ESP32-S2/S3, SAMD, nRF52, STM32; includes skeletal project and flashing tools";
        };
      };

      devShells = forEachSupportedSystem (
        {
          pkgs,
          python,
        }:
        {
          default = pkgs.mkShell {
            packages = [
              python
              # USB device detection
              pkgs.usbutils # provides lsusb for board detection

              # Flashing and debug tools for multiple boards
              pkgs.picotool # RP2040 (Pico)
              pkgs.esptool # ESP32-S2/S3
              pkgs.openocd # Universal debugger
              pkgs.bossa # SAMD21/SAMD51
              pkgs.dfu-util # DFU bootloaders

              # Python tools for CircuitPython development
              pkgs.python3Packages.pyserial
              pkgs.python3Packages.wheel
              pkgs.python3Packages.setuptools
              pkgs.python3Packages.pip
              pkgs.python3Packages.black

              # Testing and mocking frameworks
              pkgs.python3Packages.pytest
              pkgs.python3Packages.pytest-mock
              pkgs.python3Packages.pytest-cov

              # CircuitPython tools and libraries
              pkgs.circup # CircuitPython library updater
              pkgs.mpremote # Modern MicroPython device interaction (works with CircuitPython)
              pkgs.adafruit-ampy # Classic utility for board interaction
              pkgs.python3Packages.adafruit-platformdetect # Platform detection
              pkgs.python3Packages.adafruit-pureio # Hardware abstraction

              # Additional libraries via pip
              # Note: additional packages can be installed via pip in the shell

              # Serial monitoring and REPL access (using screen instead of picocom/minicom)
              pkgs.screen
              pkgs.socat

              # For building/managing CircuitPython bundles
              pkgs.git
              pkgs.gnumake
            ];
            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              # Create a Python virtualenv for pip packages
              if [ ! -d .venv ]; then
                ${python}/bin/python -m venv .venv
              fi
              source .venv/bin/activate

              # Install ampy and other tools
              pip install --quiet adafruit-ampy 2>/dev/null || true

              echo "\033[1;36m" # cyan bold
              echo "─────────────────────────────────────────────"
              echo " CircuitPython Nix DevShell (multi-board)"
              echo "─────────────────────────────────────────────"
              echo "Python: $(python --version)"
              echo "Tools: picotool, esptool, openocd, bossa, dfu-util, ampy, screen, socat"
              echo ""
              echo "Common commands:"
              echo "  make detect-board      # Auto-detect board"
              echo "  make flash             # Copy .py to CIRCUITPY drive"
              echo "  ampy --port /dev/ttyACM0 put src/main.py main.py"
              echo "  screen /dev/ttyACM0 115200   # REPL"
              echo "  pip install adafruit-circuitpython-bundle"
              echo ""
              echo "See README.md for full usage and board-specific notes."
              echo "─────────────────────────────────────────────"
              echo "\033[0m" # reset
            '';
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs, ... }:
        {
          default = pkgs.writeShellScriptBin "dev-helper" ''
            echo "CircuitPython Pico dev environment"
            command -v picotool >/dev/null 2>&1 && echo "  picotool: $(picotool --version 2>&1 | head -1)" || true
            command -v openocd >/dev/null 2>&1 && echo "  openocd: $(openocd --version 2>&1 | head -1)" || true
            command -v screen >/dev/null 2>&1 && echo "  screen: OK" || true
            echo "This binary is built by Nix (packages.default)."
          '';

          flash = pkgs.writeShellScriptBin "flash-circuitpython" ''
            #!/usr/bin/env bash
            set -euo pipefail
            UF2="''${UF2:-firmware.uf2}"
            if [ ! -e "$UF2" ]; then
              echo "UF2 file '$UF2' not found; set UF2=/path/to/firmware.uf2" >&2
              exit 1
            fi
            echo "Flashing '$UF2' to Pico with picotool (press BOOTSEL or reset into BOOTSEL first)..."
            exec ${pkgs.picotool}/bin/picotool load "$UF2" -f
          '';

          copy-usb = pkgs.writeShellScriptBin "copy-usb" ''
            #!/usr/bin/env bash
            set -euo pipefail

            # Find the mounted RP2040 device
            MOUNT_POINT=$(${pkgs.findutils}/bin/find /media -type d -name "RPI-RP2" 2>/dev/null | head -1)

            if [ -z "$MOUNT_POINT" ]; then
              echo "Error: RP2040-Zero not found in /media"
              echo "Please:"
              echo "  1. Hold BOOTSEL on the RP2040-Zero"
              echo "  2. Plug it into USB (or hold BOOTSEL + press RESET)"
              echo "  3. It should mount as a USB drive"
              echo "  4. Try again"
              exit 1
            fi

            FILE="''${1:-src/main.py}"
            if [ ! -f "$FILE" ]; then
              echo "Error: File '$FILE' not found" >&2
              exit 1
            fi

            DEST_NAME="''${2:-''$(basename $FILE)}"
            echo "Copying $FILE → $MOUNT_POINT/$DEST_NAME"
            cp "$FILE" "$MOUNT_POINT/$DEST_NAME"
            ${pkgs.coreutils}/bin/sync
            echo "Done! Press RESET on the RP2040-Zero to exit BOOTSEL mode."
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
          copy-usb = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.copy-usb;
          };
        }
      );
    };
}
