# Rust Nix Flake Template

This template provides a reproducible Rust development environment using Nix flakes and the fenix toolchain.

## Quick Start

```sh
nix develop
# or with direnv:
direnv allow
```

### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **Rust Targets**: Automatically adds common embedded Rust targets (ARM Cortex-M, RISC-V)
✓ **Cargo Paths**: Sets up `$HOME/.cargo/bin` in PATH for cargo-installed binaries
✓ **Welcome Banner**: Displays available tools and quick commands

No manual setup needed! Just start coding.

## Quickstart

```sh
nix flake init -t path:../flakes#rust
nix develop
cargo build
```

## Embedded Rust Support

The devShell automatically installs common embedded Rust targets via `rustup`:

| Target | Platform | Use Case |
|--------|----------|----------|
| `thumbv6m-none-eabi` | ARM Cortex-M0/M0+ | RP2040 (Pico) |
| `thumbv7em-none-eabihf` | ARM Cortex-M4F/M7F | STM32, nRF52840 |
| `riscv32imc-unknown-none-elf` | RISC-V 32-bit | ESP32-C3 (basic) |
| `riscv32imac-unknown-none-elf` | RISC-V 32-bit (atomic) | ESP32-C3 (advanced) |

**Note:** ESP32 Xtensa targets require espup or custom toolchains (see [esp-rs](https://github.com/esp-rs)).

## Included Tools

| Tool | Purpose |
|------|---------|
| **cargo** | Rust package manager and build system |
| **rustc** | Rust compiler |
| **clippy** | Rust linter for catching common mistakes |
| **rustfmt** | Rust code formatter |
| **rust-analyzer** | Language server for IDE integration |
| **rust-src** | Rust source code (for tools like rust-analyzer) |
| **probe-rs** | Embedded debugger/flasher for ARM targets |
| **espflash** | Flashing tool for ESP32 boards |
| **openocd** | JTAG/SWD debugger for ARM and other targets |
| **minicom** | Serial terminal for device output |
| **elf2uf2-rs** | Convert ELF to UF2 format (RP2040) |
| **picotool** | Pico-specific firmware operations |
| **avrdude** | AVR microcontroller programmer |
| **ravedude** | Rapid AVR development utility |

## Testing & Development Features

Build and testing tools:

- **cargo test** - Run unit and integration tests
- **cargo clippy** - Lint code for common issues
- **cargo fmt** - Format code consistently with rustfmt

**Example usage:**

```bash
# Run tests
cargo test

# Check code with clippy
cargo clippy

# Format code
cargo fmt

# Build for embedded target
cargo build --target thumbv7em-none-eabihf --release
```

## Project Layout

```
Cargo.toml
Cargo.lock
src/
  └── main.rs (or lib.rs)
Makefile
.envrc
flake.nix
```

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Project Metadata

See project.toml for example metadata.

## Helper Tools

- **`nix run .#dev-helper`** - Display tool versions and availability
- **`cargo build`** - Build the project
- **`cargo check`** - Quick syntax check without building
- **`cargo doc --open`** - Generate and view documentation

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Rust packaging docs](https://nixos.org/manual/nixpkgs/stable/#rust) for more details.

## Customization

Edit `flake.nix` to:

- Add additional Rust targets via `rustup target add [target]`
- Include additional cargo plugins
- Add board-specific tools (e.g., stm32cube, nrfjprog)
