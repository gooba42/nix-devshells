{
  description = "A Nix-flake-based TinyGo development environment for embedded systems and WebAssembly";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system: let
          pkgs = import nixpkgs {inherit system;};
        in
          f {inherit pkgs;}
      );
  in {
    templates = {
      default = {
        path = ./.;
        description = "TinyGo development environment for embedded systems and WebAssembly";
      };
    };

    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # TinyGo compiler
            tinygo

            # Go toolchain (dependency of TinyGo)
            go

            # Embedded/microcontroller flashing tools
            openocd
            platformio
            avrdude
            picotool
            esptool
            elf2uf2-rs

            # Build tools
            cmake
            ninja
            pkg-config

            # Debugging
            gdb
            lldb

            # WebAssembly tools
            wasmtime

            # Serial monitoring
            screen

            # Version control & utilities
            git
            curl
            wget
          ];

          shellHook = ''
            echo "TinyGo Development Environment"
            echo "==============================="
            echo "TinyGo: Compile Go to embedded systems & WebAssembly"
            echo ""
            echo "Supported targets:"
            echo "  - 100+ microcontroller boards (Arduino, micro:bit, Pico, etc.)"
            echo "  - WebAssembly (WASM/WASI)"
            echo ""
            echo "Quick commands:"
            echo "  tinygo version            - Show TinyGo version"
            echo "  tinygo list-targets       - List supported boards"
            echo "  tinygo build -target uno -o blink.hex examples/blink.go"
            echo "  tinygo build -target wasm -o main.wasm examples/wasm.go"
            echo ""
            echo "Flash Arduino:"
            echo "  tinygo flash -target uno -port /dev/ttyACM0 examples/blink.go"
            echo ""
            echo "Flash Pico:"
            echo "  tinygo flash -target pico examples/blink.go"
            echo ""
            echo "Tools available: tinygo, go, openocd, avrdude, picotool, esptool, wasmtime"
          '';
        };
      }
    );

    packages = forEachSupportedSystem (
      {pkgs}: {
        default = pkgs.writeShellScriptBin "dev-helper" ''
          echo "TinyGo dev environment"
          command -v tinygo >/dev/null 2>&1 && echo "  tinygo: $(tinygo version)" || true
          command -v go >/dev/null 2>&1 && echo "  go: $(go version | cut -d' ' -f3)" || true
          command -v wasmtime >/dev/null 2>&1 && echo "  wasmtime: OK" || true
          echo "This binary is built by Nix (packages.default)."
        '';

        build-arduino = pkgs.writeShellScriptBin "build-arduino" ''
          #!/usr/bin/env bash
          set -euo pipefail
          BOARD="''${1:-uno}"
          SOURCE="''${2:-src/main.go}"
          OUTPUT="''${3:-build/main.hex}"
          mkdir -p build
          echo "Building TinyGo for Arduino ($BOARD) from $SOURCE..."
          exec ${pkgs.tinygo}/bin/tinygo build -target "$BOARD" -o "$OUTPUT" "$SOURCE"
        '';

        build-pico = pkgs.writeShellScriptBin "build-pico" ''
          #!/usr/bin/env bash
          set -euo pipefail
          SOURCE="''${1:-src/main.go}"
          OUTPUT="''${2:-build/main.uf2}"
          mkdir -p build
          echo "Building TinyGo for Raspberry Pi Pico from $SOURCE..."
          exec ${pkgs.tinygo}/bin/tinygo build -target pico -o "$OUTPUT" "$SOURCE"
        '';

        build-wasm = pkgs.writeShellScriptBin "build-wasm" ''
          #!/usr/bin/env bash
          set -euo pipefail
          SOURCE="''${1:-src/main.go}"
          OUTPUT="''${2:-build/main.wasm}"
          mkdir -p build
          echo "Building TinyGo for WebAssembly from $SOURCE..."
          exec ${pkgs.tinygo}/bin/tinygo build -target wasm -o "$OUTPUT" "$SOURCE"
        '';

        flash-arduino = pkgs.writeShellScriptBin "flash-arduino" ''
          #!/usr/bin/env bash
          set -euo pipefail
          BOARD="''${1:-uno}"
          PORT="''${2:-/dev/ttyACM0}"
          SOURCE="''${3:-src/main.go}"
          echo "Building and flashing TinyGo to Arduino ($BOARD) on port $PORT..."
          exec ${pkgs.tinygo}/bin/tinygo flash -target "$BOARD" -port "$PORT" "$SOURCE"
        '';

        flash-pico = pkgs.writeShellScriptBin "flash-pico" ''
          #!/usr/bin/env bash
          set -euo pipefail
          SOURCE="''${1:-src/main.go}"
          echo "Building and flashing TinyGo to Raspberry Pi Pico..."
          echo "Hold BOOTSEL button on Pico and plug USB..."
          exec ${pkgs.tinygo}/bin/tinygo flash -target pico "$SOURCE"
        '';
      }
    );

    apps = forEachSupportedSystem (
      {pkgs}: {
        default = {
          type = "app";
          program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
        build-arduino = {
          type = "app";
          program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.build-arduino;
        };
        build-pico = {
          type = "app";
          program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.build-pico;
        };
        build-wasm = {
          type = "app";
          program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.build-wasm;
        };
        flash-arduino = {
          type = "app";
          program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.flash-arduino;
        };
        flash-pico = {
          type = "app";
          program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.flash-pico;
        };
      }
    );
  };
}
