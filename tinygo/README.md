# TinyGo Development Environment

A production-ready Nix flake-based development environment for **TinyGo** — a Go compiler for small places.

Compile Go programs to over 100 embedded systems and WebAssembly with TinyGo's LLVM-based compiler.

## Features

- 🎯 **100+ microcontroller targets**: Arduino, micro:bit, Raspberry Pi Pico, STM32, Nordic nRF, etc.
- 🕷️ **WebAssembly support**: Compile Go to WASM/WASI for web and edge computing
- 🔧 **Full dev environment**: TinyGo, Go, debugging tools, flashing utilities
- 📦 **Nix packaging**: Build with `nix build .` and helpers for common tasks
- ⚡ **Helper apps**: `nix run .#flash-*` and `nix run .#build-*` commands
- 🧪 **Example projects**: Blink for embedded, WebAssembly examples included
- 📚 **Multi-platform support**: x86_64-linux, aarch64-linux, macOS (Intel & Apple Silicon)

## Quick Start

### Initialize from Template

```bash
nix flake init -t templates#tinygo
cd tinygo
nix develop
```

Or directly:

```bash
nix flake init -t '/home/gooba42/Documents/Projects/nix/nixos#tinygo'
direnv allow  # if using direnv
```

### List Supported Targets

```bash
nix develop -c tinygo list-targets
```

Sample output includes: `arduino-uno`, `arduino-mega`, `pico`, `pico-rp2040`, `esp8266`, `esp32`, `microbit`, `wasm`, `wasip1`, and 90+ more.

### Build a Program

```bash
# Arduino Uno
nix run .#build-arduino -- uno src/main.go build/main.hex

# Raspberry Pi Pico
nix run .#build-pico -- src/main.go build/main.uf2

# WebAssembly
nix run .#build-wasm -- src/main.go build/main.wasm
```

Or directly in devshell:

```bash
tinygo build -target uno -o main.hex src/main.go
tinygo build -target pico -o main.uf2 src/main.go
tinygo build -target wasm -o main.wasm src/main.go
```

### Flash to Board

```bash
# Arduino (auto-flash)
nix run .#flash-arduino -- uno /dev/ttyACM0 src/main.go

# Pico (hold BOOTSEL, then plug USB)
nix run .#flash-pico -- src/main.go

# Direct TinyGo flash command
tinygo flash -target uno -port /dev/ttyACM0 src/main.go
```

## Project Structure

```
tinygo/
├── flake.nix               # Nix flake with build/flash helpers
├── .envrc                  # direnv configuration
├── README.md               # This file
├── src/
│   └── main.go             # Default blink program
└── examples/
    ├── blink/
    │   └── main.go         # Arduino blink example
    └── wasm/
        └── main.go         # WebAssembly example
```

## Supported Targets

### Microcontroller Boards

| Board | TinyGo Target | Type | Features |
|-------|--------------|------|----------|
| Arduino Uno | `arduino-uno` | AVR | 8-bit, 2KB RAM |
| Arduino Mega | `arduino-mega` | AVR | 8-bit, 8KB RAM |
| Raspberry Pi Pico | `pico` | ARM | 32-bit Cortex-M0+ |
| BBC micro:bit | `microbit` | ARM | 32-bit Cortex-M4 |
| ESP32 | `esp32` | Xtensa | 32-bit, dual-core |
| ESP8266 | `esp8266` | Xtensa | 32-bit, single-core |
| STM32L0 | `stm32l0-discovery` | ARM | 32-bit Cortex-M0+ |
| Nordic nRF52 | `nrf52840-mdk` | ARM | 32-bit Cortex-M4 |

See full list with: `tinygo list-targets`

### WebAssembly

| Target | Format | Use Case |
|--------|--------|----------|
| `wasm` | Browser WASM | Web applications |
| `wasip1` | WASI | Server/edge computing |

## Development Workflow

### 1. Enter Development Shell

```bash
nix develop
# or with direnv (after running `direnv allow`)
direnv allow && cd .
```

### 2. Write Go Code

Edit `src/main.go` for embedded targets, or `examples/wasm/main.go` for WebAssembly.

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})
    
    for {
        led.High()
        time.Sleep(500 * time.Millisecond)
        
        led.Low()
        time.Sleep(500 * time.Millisecond)
    }
}
```

### 3. Build

```bash
tinygo build -target uno -o main.hex src/main.go
```

### 4. Flash

```bash
# One-step build + flash for Arduino
tinygo flash -target uno -port /dev/ttyACM0 src/main.go

# Or for Pico (must be in bootloader mode)
tinygo flash -target pico src/main.go
```

### 5. Debug/Monitor

Use serial monitor to see `println()` output:

```bash
screen /dev/ttyACM0 115200
# Or: picocom /dev/ttyACM0 -b 115200
# Exit screen: Ctrl-A, K, Y
```

## Build Helpers

### Build Commands

```bash
# Build for Arduino Uno
nix run .#build-arduino -- uno src/main.go build/main.hex

# Build for Arduino Mega (use custom source/output)
nix run .#build-arduino -- mega src/blink.go output.hex

# Build for Raspberry Pi Pico
nix run .#build-pico -- src/main.go build/main.uf2

# Build WebAssembly
nix run .#build-wasm -- src/main.go build/main.wasm
```

### Flash Commands

```bash
# Flash Arduino (auto-detect port or specify)
nix run .#flash-arduino -- uno /dev/ttyACM0 src/main.go

# Flash Pico (auto-detect, or hold BOOTSEL)
nix run .#flash-pico -- src/main.go

# Direct command (from nix develop)
flash-arduino uno /dev/ttyACM0 src/main.go
flash-pico src/main.go
```

## Troubleshooting

### "Port not found" or "Permission denied"

**Linux:**

```bash
# Add user to dialout group
sudo usermod -a -G dialout $USER
# Log out and log back in
```

**Verify port:**

```bash
ls -la /dev/tty*  # Look for ttyACM*, ttyUSB*, etc.
dmesg | tail -20  # Check kernel logs
```

### TinyGo not found

Make sure you're inside the devshell:

```bash
nix develop
tinygo version
```

### Build fails with "target not found"

List available targets:

```bash
tinygo list-targets
```

### Pico "Not in bootloader mode"

Hold BOOTSEL button while plugging Pico into USB, or:

```bash
# If Pico is already running code, reset to bootloader
picotool reboot -a -ub
```

### WebAssembly build issues

Ensure you're building for `wasm` or `wasip1` target:

```bash
tinygo build -target wasm -o main.wasm examples/wasm/main.go

# Run with wasmtime
wasmtime main.wasm
```

## Tools Included

In the Nix dev shell:

| Tool | Purpose |
|------|---------|
| **tinygo** | TinyGo compiler |
| **go** | Go toolchain (dependency) |
| **openocd** | JTAG/SWD debugging |
| **avrdude** | AVR programming |
| **picotool** | Pico flashing/debugging |
| **esptool** | ESP flashing |
| **gdb** | Debugging |
| **wasmtime** | WebAssembly runtime |
| **wasm-pack** | WASM tooling |
| **cmake, ninja** | Build tools |
| **screen** | Serial monitoring |

## Example Workflows

### Blink LED on Arduino Uno

```bash
nix develop
tinygo build -target arduino-uno -o blink.hex src/main.go
tinygo flash -target arduino-uno -port /dev/ttyACM0 src/main.go
```

### Build WebAssembly & Run

```bash
nix develop
tinygo build -target wasm -o main.wasm examples/wasm/main.go
wasmtime main.wasm
```

### Debug with GDB

```bash
nix develop

# Build with debug info
tinygo build -target pico -o main.uf2 src/main.go

# Flash to Pico, then:
openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg
# In another terminal:
gdb build/main.elf
```

## Customization

### Add a New Target

Most targets are automatically available through TinyGo's `tinygo list-targets`.

To add a board-specific helper script, edit `flake.nix` and add a package entry:

```nix
build-myboard = pkgs.writeShellScriptBin "build-myboard" ''
  #!/usr/bin/env bash
  set -euo pipefail
  SOURCE="''${1:-src/main.go}"
  OUTPUT="''${2:-build/myboard.hex}"
  mkdir -p build
  echo "Building for MyBoard..."
  exec ${pkgs.tinygo}/bin/tinygo build -target myboard-target -o "$OUTPUT" "$SOURCE"
'';
```

Then register it as an app and use: `nix run .#build-myboard`

### Configure Serial Baud Rate

TinyGo programs use platform-default serial speeds. To change in code:

```go
// For targets that support it
machine.Serial.Configure(machine.UARTConfig{
    BaudRate: 115200,
})
```

## References

- [TinyGo Official](https://tinygo.org/)
- [TinyGo Docs](https://tinygo.org/docs/)
- [Supported Boards](https://tinygo.org/docs/reference/microcontrollers)
- [Go Package Docs](https://pkg.go.dev/github.com/tinygo-org/tinygo)
- [WebAssembly Support](https://tinygo.org/docs/guides/webassembly/)
- [GitHub Repository](https://github.com/tinygo-org/tinygo)

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs TinyGo packaging docs](https://nixos.org/manual/nixpkgs/stable/#go) for more details.

## License

This template is provided as-is for educational and commercial use.
