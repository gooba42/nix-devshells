{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

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
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.self.overlays.default
              ];
            };
          }
        );
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "Rust dev environment using fenix; includes a skeletal Cargo project and packaged helper app";
        };
      };

      overlays.default = _final: prev: {
        rustToolchain =
          with inputs.fenix.packages.${prev.stdenv.hostPlatform.system};
          combine (
            with stable;
            [
              clippy
              rustc
              cargo
              rustfmt
              rust-src
            ]
          );
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              rustToolchain
              git
              gnumake
              openssl
              pkg-config
              cargo-deny
              cargo-edit
              cargo-watch
              cargo-generate
              rust-analyzer
              rustup
              # Embedded Rust tooling
              probe-rs-tools
              espflash
              openocd
              minicom
              # RP2040 UF2 workflows
              elf2uf2-rs
              picotool
              avrdude
              pkgsCross.avr.buildPackages.libc
              pkgsCross.avr.buildPackages.gcc
              ravedude
            ];

            env = {
              # Required by rust-analyzer
              RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
            };

            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              # Ensure user's Cargo-installed binaries are available
              export PATH="$HOME/.cargo/bin:$PATH"

              if command -v rustup >/dev/null 2>&1; then
                echo "Ensuring common embedded Rust targets are available (idempotent)..."
                rustup target add thumbv6m-none-eabi       >/dev/null 2>&1 || true  # Cortex-M0/M0+ (RP2040)
                rustup target add thumbv7em-none-eabihf    >/dev/null 2>&1 || true  # Cortex-M4F/M7F (many STM32/nRF52)
                rustup target add riscv32imc-unknown-none-elf >/dev/null 2>&1 || true
                rustup target add riscv32imac-unknown-none-elf >/dev/null 2>&1 || true  # ESP32-C3 class
                echo "Note: ESP32 Xtensa targets require espup/custom toolchains (see esp-rs)."
              fi
              echo "[rust-template] Welcome to the Rust dev shell!"
              echo "Tools: cargo, rustc, clippy, rustfmt, rust-analyzer, probe-rs, espflash, openocd, minicom, elf2uf2-rs, picotool, avrdude, ravedude"
              echo "Run 'cargo build' to build, or 'nix run .#dev-helper' for a tool summary."
              echo "See README.md for usage."
            '';
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs }:
        {
          # Build the skeletal Cargo project
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "sample-rust-app";
            version = "0.1.0";
            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;
          };

          devHelper = pkgs.writeShellScriptBin "dev-helper" ''
            echo "Rust toolchain available:"
            command -v cargo >/dev/null 2>&1 && cargo --version || true
            command -v rustc >/dev/null 2>&1 && rustc --version || true
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
          dev-helper = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.devHelper;
          };
        }
      );
    };
}
