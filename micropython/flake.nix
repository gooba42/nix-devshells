{
  description = "A Nix-flake-based MicroPython development environment for ESP32, ESP8266, Pico, and STM32";

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
          in
          f { inherit pkgs; }
        );
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "MicroPython dev environment for ESP32, ESP8266, RP2040, STM32; includes flashing and REPL tools";
          welcomeText = ''
            MicroPython project initialized.
            Supported boards: ESP32, ESP8266, Raspberry Pi Pico, STM32
            - Flash ESP32:   esptool.py --chip esp32 --port /dev/ttyUSB0 write_flash -z 0x1000 firmware.bin
            - Flash Pico:    picotool load firmware.uf2
            - Upload file:   ampy --port /dev/ttyUSB0 put main.py
            - REPL:          screen /dev/ttyUSB0 115200
          '';
        };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Python for tooling
              python3
              python3Packages.pip
              python3Packages.pyserial

              # Flashing tools for different boards
              esptool # ESP32, ESP8266
              picotool # Raspberry Pi Pico (RP2040)
              dfu-util # STM32 and other DFU bootloaders
              openocd # Universal debugger
              stm32flash # STM32 serial flasher

              # Serial communication and REPL access
              screen
              minicom

              # Build tools (if building MicroPython from source)
              git
              cmake
              gcc
            ];

            shellHook = ''
              # Create venv for Python tools
              if [ ! -d .venv ]; then
                python3 -m venv .venv
              fi
              source .venv/bin/activate

              # Install MicroPython tools
              pip install --quiet adafruit-ampy mpremote rshell 2>/dev/null || true

              echo "MicroPython development environment ready"
              echo ""
              echo "Tools available:"
              echo "  - esptool:   ESP32/ESP8266 flashing"
              echo "  - picotool:  RP2040 (Pico) flashing"
              echo "  - dfu-util:  STM32 DFU flashing"
              echo "  - ampy:      File upload to device"
              echo "  - mpremote:  MicroPython REPL and file operations"
              echo "  - rshell:    Remote shell for MicroPython"
              echo "  - screen:    Serial terminal"
              echo ""
              echo "Quick start:"
              echo "  1. Download MicroPython firmware from micropython.org/download"
              echo "  2. Flash: esptool.py --port /dev/ttyUSB0 write_flash -z 0x1000 firmware.bin"
              echo "  3. Upload: ampy --port /dev/ttyUSB0 put src/main.py"
              echo "  4. REPL:   screen /dev/ttyUSB0 115200"
            '';
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.writeShellScriptBin "micropython-helper" ''
            echo "MicroPython development helper"
            echo ""
            echo "Available tools:"
            command -v esptool.py >/dev/null 2>&1 && echo "  ✓ esptool (ESP32/ESP8266)"
            command -v picotool >/dev/null 2>&1 && echo "  ✓ picotool (RP2040)"
            command -v dfu-util >/dev/null 2>&1 && echo "  ✓ dfu-util (STM32)"
            command -v ampy >/dev/null 2>&1 && echo "  ✓ ampy (file upload)"
            command -v mpremote >/dev/null 2>&1 && echo "  ✓ mpremote (REPL)"
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
