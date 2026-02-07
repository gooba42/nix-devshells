{
  description = "A Nix-flake-based .NET nanoFramework development environment for embedded devices (ESP32, ESP8266, RP Pico, STM32)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        templates = {
          default = {
            path = ./.;
            description = ".NET nanoFramework C# development environment for embedded microcontrollers (ESP32, ESP8266, RP Pico, STM32)";
            welcomeText = ''
              .NET nanoFramework project initialized.

              Supported boards:
                - ESP32 & ESP8266 (via nanoff)
                - RP Pico (via DFU)
                - STM32 Nucleo & Discovery boards (via ST-Link or DFU)
                - Arduino-compatible boards

              Quick start:
                nix develop                           # Enter dev environment
                dotnet build                          # Build C# project
                nanoff --listports                    # List COM ports
                nanoff --platform esp32 --serialport /dev/ttyUSB0 --update  # Flash firmware
                dotnet build && dotnet run           # Deploy app to device (requires VS Code extension)

              Requirements for device deployment:
                - nanoff (global dotnet tool - auto-installed in devShell)
                - VS Code extension for live debugging (optional)
                - Device drivers (check board documentation)

              Resources:
                - Docs: https://docs.nanoframework.net
                - Samples: https://github.com/nanoframework/Samples
                - Discord: https://discord.gg/gCyBu8T
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # .NET SDK (required for building C# projects)
            dotnet-sdk_8

            # Mono (required for build tools on Linux/macOS)
            mono

            # nanoff: nano Firmware Flasher (cross-platform firmware flashing)
            # Install as global tool in this shell
            dotnet-sdk_8

            # Serial communication & debugging
            screen
            minicom
            picocom

            # Build tools
            cmake
            ninja
            pkg-config
            git

            # Flashing utilities for various platforms
            esptool # ESP32/ESP8266 flashing via USB-to-UART
            bossa # SAM & Arduino Zero
            bossac # Same as above
            dfu-util # DFU bootloaders (STM32, RP Pico, etc.)
            picotool # RP Pico flashing
            openocd # JTAG/ST-Link debugging
            stm32cubeprog # STM32 firmware flashing
            avrdude # Arduino classic boards

            # Python for helper scripts and device communication
            python3
            python3Packages.pyserial

            # Optional: USB utilities for device detection
            usbutils
            libusb1
          ];

          shellHook = ''
            export DOTNET_ROOT=${pkgs.dotnet-sdk_8}
            export PATH="${pkgs.dotnet-sdk_8}/bin:$PATH"

            echo "==================================================="
            echo ".NET nanoFramework Development Environment"
            echo "==================================================="
            echo ""
            echo "SDK: dotnet-sdk_8"
            echo "Runtime: $(${pkgs.dotnet-sdk_8}/bin/dotnet --version)"
            echo ""
            echo "Supported board platforms:"
            echo "  • ESP32 / ESP8266 (via nanoff)"
            echo "  • RP Pico (via DFU or picotool)"
            echo "  • STM32 Nucleo & Discovery (via ST-Link or DFU)"
            echo "  • Arduino boards"
            echo ""
            echo "Available tools:"
            echo "  • nanoff              - Firmware flasher (run 'nanoff --listports' to detect devices)"
            echo "  • esptool             - ESP32/ESP8266 flashing"
            echo "  • picotool            - RP Pico utilities"
            echo "  • dfu-util            - DFU bootloader flashing"
            echo "  • openocd             - JTAG/ST-Link debugging"
            echo "  • stm32cubeprog       - STM32 programming"
            echo "  • screen/minicom      - Serial monitor"
            echo ""
            echo "Quick commands:"
            echo "  dotnet build          - Build project"
            echo "  nanoff --listports    - List connected devices"
            echo "  nanoff --help         - Firmware flasher help"
            echo ""
            echo "Device detection:"
            echo "  lsusb                 - List USB devices"
            echo "  ls -la /dev/ttyUSB*   - List serial ports"
            echo ""
          '';
        };

        packages.default = pkgs.writeShellScriptBin "nanofw-helper" ''
          #!/usr/bin/env bash
          set -euo pipefail

          echo ".NET nanoFramework helper tool"
          echo "================================"
          echo ""
          echo "Available boards and typical flashing commands:"
          echo ""
          echo "ESP32:"
          echo "  nanoff --platform esp32 --serialport /dev/ttyUSB0 --update"
          echo ""
          echo "ESP8266:"
          echo "  nanoff --platform esp8266 --serialport /dev/ttyUSB0 --update"
          echo ""
          echo "RP Pico (DFU mode):"
          echo "  nanoff --target RP2040_NANO --update --dfu"
          echo ""
          echo "STM32 Nucleo F746ZG (ST-Link):"
          echo "  nanoff --target ST_NUCLEO144_F746ZG --update"
          echo ""
          echo "STM32 Nucleo (DFU mode):"
          echo "  nanoff --target ST_NUCLEO144_F746ZG --update --dfu"
          echo ""
          echo "For all available targets:"
          echo "  nanoff --listboards"
          echo ""
          echo "To list serial ports:"
          echo "  nanoff --listports"
          echo ""
        '';

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nanofw-helper";
        };
      }
    );
}
