# Language Development Templates

Reusable Nix flake templates for bootstrapping language-specific development environments. Each template provides a complete dev shell, direnv support, and example project structure.

## Quick Start

Initialize a new project with any template:

```bash
nix flake init -t /path/to/flakes#<template-name>
```

Or from this repository:

```bash
nix flake init -t github:gooba42/nixos-ng?dir=flakes#<template-name>
```

## Available Templates

### General Purpose

| Template | Use Case | Key Tools |
|----------|----------|-----------|
| `python` | General Python development, data science, scripts | Python 3.11+, pip, venv, direnv |
| `rust` | Systems programming, CLI tools, WASM | Rust stable (fenix), clippy, rustfmt |
| `golang` | Backend services, CLI tools | Go 1.24, gotools, golangci-lint |
| `c` | Systems programming, low-level development | GCC, Make, CMake |
| `cpp-devshell` | C++ development | GCC/Clang, CMake, build tools |
| `java` | Enterprise applications, Android | OpenJDK, Maven/Gradle |
| `dotnet` | .NET applications, ASP.NET | .NET SDK, EF Core, optional Rider |

### Specialized

| Template | Use Case | Key Tools |
|----------|----------|-----------|
| `jupyter` | Data analysis, notebook-based development | JupyterLab, ipykernel, poetry |
| `openscad-dev` | 3D CAD modeling, parametric design, 3D printing | OpenSCAD, MeshLab, openscad-lsp |
| `nanoframework` | Embedded .NET with C# for microcontrollers | .NET SDK, nanoff, esptool, dfu-util |
| `micropython` | Interpreted Python for microcontrollers | esptool, picotool, ampy, mpremote |
| `circuitpython` | CircuitPython for RP2040, ESP32-S2/S3, SAMD, nRF52 | esptool, picotool, bossac, ampy |
| `embedded-rust` | Embedded systems with Rust | Rust embedded toolchain |
| `tinygo` | Microcontrollers with Go | TinyGo compiler |
| `arduino` | C++/Arduino for AVR, ESP32, STM32, RP2040 | PlatformIO, avr-gcc, avrdude |
| `ft232h` | USB serial interface development | FT232H libraries |

## Microcontroller Development Guide

**Choose your language, not your board:**

| Language | Template | Supported Boards |
|----------|----------|------------------|
| **C#** | `nanoframework` | ESP32, ESP8266, Pico, STM32 |
| **Python (interpreted)** | `micropython` | ESP32, ESP8266, Pico, STM32, PyBoard |
| **Python (CircuitPython)** | `circuitpython` | RP2040, ESP32-S2/S3, SAMD, nRF52, STM32F4 |
| **C++/Arduino** | `arduino` | AVR, ESP32, ESP8266, STM32, RP2040, SAMD, ARM Cortex |
| **Rust** | `embedded-rust` | ARM Cortex-M, RISC-V, ESP, STM32, Pico |
| **Go** | `tinygo` | ARM Cortex-M, AVR, ESP, WASM |

**Board-specific notes:**

- **Arduino (AVR)**: Use `arduino` template with PlatformIO
- **ESP32/ESP8266**: All templates support these (choose language)
- **Raspberry Pi Pico**: Use `micropython`, `circuitpython`, `arduino`, or `embedded-rust`
- **STM32**: All templates support (MicroPython, CircuitPython, nanoFramework, Arduino, Rust)

**Configure boards in project files:**

- Arduino/C++: Edit `platformio.ini`
- Rust: Edit `.cargo/config.toml`
- Python: Flash appropriate firmware, code is portable

## Template Features

All templates include:

- **DevShell**: Drop into a reproducible development environment with `nix develop`
- **Direnv support**: Auto-activate environment when entering directory (`.envrc` provided)
- **Packages**: Most templates include a `packages.default` for building the example app
- **Apps**: Launch helper utilities with `nix run`

## Usage Examples

### Python

```bash
nix flake init -t .#python
nix develop
# or with direnv:
direnv allow
```

The Python template provides a reusable devShell function:

```nix
# Import into your own flake:
mkPythonShell = (import /path/to/flakes/python).mkPythonShell;
devShells.default = mkPythonShell { inherit pkgs; pythonVersion = "3.12"; };
```

### Rust

```bash
nix flake init -t .#rust
nix develop
cargo build
```

### .NET

```bash
nix flake init -t .#dotnet
nix develop
dotnet build
dotnet run
```

Rider IDE works inside the FHS environment: `rider .` (from within `nix develop`)

### Go

```bash
nix flake init -t .#golang
nix develop
go build
```

## Customization

Each template is self-contained and can be customized:

1. **Copy the template** to your project
2. **Edit `flake.nix`** to adjust versions, packages, or environment variables
3. **Lock dependencies**: `nix flake update` (generates `flake.lock`)
4. **Test**: `nix flake check`

**Note on reproducibility:** The template library's `flake.lock` is tracked for consistent nixpkgs versions across templates. Individual templates don't track their locks—users generate fresh locks when initializing projects.

## Template Structure

Typical template layout:

```
template-name/
├── flake.nix          # Nix flake definition
├── flake.lock         # Pinned input versions (if present)
├── .envrc             # Direnv auto-loader
├── README.md          # Template-specific docs (optional)
└── <project-files>    # Example app or library
```

## Contributing

When adding new templates:

1. Follow existing structure (devShells, packages, apps)
2. Include `welcomeText` in template definition if helpful
3. Add direnv support with `.envrc`
4. Update this README with template entry
5. Update `flakes/flake.nix` template registry

## Related Documentation

- [NixOS Flakes Manual](https://nixos.wiki/wiki/Flakes)
- [Nix Development Environments](https://nix.dev/tutorials/first-steps/dev-environment)
- [Direnv Integration](../docs/DIRENV_INTEGRATION.md)

  nix bundle --bundler github:NixOS/bundlers#pyinstaller .#default
- Rust (static-friendly busybox bundler):
  nix bundle --bundler github:NixOS/bundlers#busybox .#default
- Result appears under ./result (copy it anywhere to run without Nix).

Per-template suggestions

- C/C++: nix bundle --bundler github:NixOS/bundlers#busybox .#default
- Java:  nix bundle --bundler github:NixOS/bundlers#jlink .#default
- .NET:  nix bundle --bundler github:NixOS/bundlers#dotnet .#default
- Arduino/Pico/ESP: bundling usually not needed; use platform-specific flashing tools. The helper binaries can still be bundled with busybox bundler if desired.
- Microcontroller (unified): See `microcontroller/README.md` for multi-platform flashing guidance. Includes `nix run .#flash-*` helpers for Arduino, Pico, and ESP variants.
- TinyGo: See `tinygo/README.md` for Go-based embedded and WebAssembly development. Use `nix run .#build-*` and `nix run .#flash-*` for targeting 100+ microcontroller boards and WASM.
- Embedded Rust: See `embedded-rust/README.md` for ARM Cortex-M, RISC-V, and other microcontroller development. Includes `probe-rs`, `openocd`, and device HAL support for hardware debugging and flashing.

Notes

- The helper app is intentionally minimal (a shell script) to show packaging and to verify key tools are present.
- You can replace it with your own project packaging as you develop. For language-specific packaging examples, expand the flake as needed (e.g., buildRustPackage, buildPythonApplication, Gradle/Maven derivations).
- **All flakes use `github:NixOS/nixpkgs/nixos-unstable`** for the latest user-space tooling while keeping your system on a stable NixOS channel.
