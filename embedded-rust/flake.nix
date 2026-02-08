{
  description = "A Nix-flake-based Rust embedded systems development environment for ARM Cortex-M, RISC-V, and other microcontrollers";

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
          description = "Embedded Rust development environment for microcontrollers (ARM Cortex-M, RISC-V, etc.)";
        };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Rust toolchain with embedded targets
              rustup
              cargo
              rust-analyzer

              # Debugging and flashing
              openocd
              gdb
              lldb
              probe-rs-tools

              # Embedded flashing tools
              picotool
              esptool

              # Build and analysis
              cmake
              ninja
              pkg-config
              binutils

              # Code analysis and formatting
              clippy
              rustfmt

              # Utilities
              git
              curl
              wget
              jq
            ];

            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              echo "Embedded Rust Development Environment"
              echo "======================================"
              echo "Supports: ARM Cortex-M, RISC-V, AVR, and more"
              echo ""
              echo "Quick start:"
              echo "  cargo new --bin myproject"
              echo "  cd myproject"
              echo "  rustup target add thumbv7em-none-eabihf  # ARM Cortex-M4"
              echo "  cargo build --target thumbv7em-none-eabihf"
              echo ""
              echo "Available targets:"
              echo "  rustup target list | grep installed"
              echo ""
              echo "Flash to board with probe-rs:"
              echo "  cargo install cargo-embed"
              echo "  cargo embed --chip stm32f303xc --release"
              echo ""
              echo "Debug with OpenOCD + GDB:"
              echo "  openocd -f openocd.cfg &"
              echo "  gdb target/thumbv7em-none-eabihf/release/app"
              echo "  (gdb) target remote localhost:3333"
              echo "  (gdb) load && continue"
              echo ""
              echo "Tools: rustup, cargo, probe-rs-tools, openocd, gdb, lldb"
              echo ""
              echo "Note: Use 'rustup' to install platform-specific targets and components"
            '';
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.writeShellScriptBin "dev-helper" ''
            echo "Embedded Rust dev environment"
            command -v rustc >/dev/null 2>&1 && echo "  rustc: $(rustc --version)" || true
            command -v cargo >/dev/null 2>&1 && echo "  cargo: $(cargo --version)" || true
            command -v probe-rs >/dev/null 2>&1 && echo "  probe-rs-tools: OK" || true
            command -v openocd >/dev/null 2>&1 && echo "  openocd: OK" || true
            command -v gdb >/dev/null 2>&1 && echo "  gdb: OK" || true
            echo "This binary is built by Nix (packages.default)."
          '';

          build-cortex-m = pkgs.writeShellScriptBin "build-cortex-m" ''
            #!/usr/bin/env bash
            set -euo pipefail
            PROFILE="''${1:-release}"
            TARGET="''${2:-thumbv7em-none-eabihf}"
            echo "Building Embedded Rust for ARM Cortex-M (target: $TARGET, profile: $PROFILE)..."
            exec cargo build --''$PROFILE --target "$TARGET"
          '';

          build-riscv = pkgs.writeShellScriptBin "build-riscv" ''
            #!/usr/bin/env bash
            set -euo pipefail
            PROFILE="''${1:-release}"
            TARGET="''${2:-riscv32imac-unknown-none-elf}"
            echo "Building Embedded Rust for RISC-V (target: $TARGET, profile: $PROFILE)..."
            exec cargo build --''$PROFILE --target "$TARGET"
          '';

          flash-cortex-m = pkgs.writeShellScriptBin "flash-cortex-m" ''
            #!/usr/bin/env bash
            set -euo pipefail
            CHIP="''${1:-stm32f303xc}"
            PROFILE="''${2:-release}"
            TARGET="''${3:-thumbv7em-none-eabihf}"
            echo "Building and flashing ARM Cortex-M (chip: $CHIP, target: $TARGET)..."
            echo "Note: probe-rs-tools provides the 'probe-rs' command"
            exec probe-rs run --chip "$CHIP" --profile "$PROFILE" --target "$TARGET"
          '';

          flash-openocd = pkgs.writeShellScriptBin "flash-openocd" ''
            #!/usr/bin/env bash
            set -euo pipefail
            ELF="''${1:-target/thumbv7em-none-eabihf/release/app}"
            CONFIG="''${2:-openocd.cfg}"
            if [ ! -f "$ELF" ]; then
              echo "ELF binary not found: $ELF" >&2
              echo "Build first with: cargo build --release --target thumbv7em-none-eabihf" >&2
              exit 1
            fi
            if [ ! -f "$CONFIG" ]; then
              echo "Warning: OpenOCD config not found: $CONFIG" >&2
              echo "Using default interface/target setup" >&2
              CONFIG="/dev/null"
            fi
            echo "Starting OpenOCD with $CONFIG..."
            echo "In another terminal, run:"
            echo "  arm-none-eabi-gdb $ELF"
            echo "  (gdb) target remote localhost:3333"
            echo "  (gdb) load"
            echo "  (gdb) continue"
            exec ${pkgs.openocd}/bin/openocd -f "$CONFIG"
          '';

          check = pkgs.writeShellScriptBin "check" ''
            #!/usr/bin/env bash
            set -euo pipefail
            TARGET="''${1:-thumbv7em-none-eabihf}"
            echo "Checking Embedded Rust for target: $TARGET"
            cargo check --target "$TARGET"
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
          build-cortex-m = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.build-cortex-m;
          };
          build-riscv = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.build-riscv;
          };
          flash-cortex-m = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.flash-cortex-m;
          };
          flash-openocd = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.flash-openocd;
          };
          check = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.check;
          };
        }
      );
    };
}
