# Arduino/AVR Nix Flake Template

This template provides a reproducible Arduino/AVR C++ development environment using Nix flakes and PlatformIO.

## Quickstart

```sh
nix flake init -t path:../flakes#arduino
nix develop
platformio run
nix run .#flash
```

## Features

- DevShell with platformio, avrdude, avr-gcc, esptool, bossa, dfu-util, picotool, pyserial
- Example platformio.ini and src/
- Helper app: `nix run .#dev-helper`
- Flash helper: `nix run .#flash`

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Project Metadata

See project.toml for example metadata.

---

## Supported Platforms

| Platform | Examples | Framework |
|----------|----------|-----------|
| **AVR** | Arduino Uno, Mega, Nano | Arduino |
| **ESP32** | ESP32, ESP32-S2/S3, ESP32-C3 | Arduino, ESP-IDF |
| **ESP8266** | NodeMCU, WeMos D1 | Arduino |
| **STM32** | Nucleo, Discovery, Blue Pill | Arduino, STM32Cube |
| **RP2040** | Raspberry Pi Pico | Arduino |
| **ARM Cortex-M** | Teensy, Adafruit Feather | Arduino, mbed |
| **SAMD** | Arduino Zero, M0 Pro | Arduino |

## Included Project Layout

```
platformio.ini
src/
Makefile
```

You can use this as a starting point for your own Arduino/AVR project.

## Features

- **PlatformIO** — Universal embedded development platform
- **C++ Tooling** — Inherited from cpp-devshell (clang, cmake, gdb, cppcheck)
- **AVR Toolchain** — avr-gcc for classic Arduino boards
- **Multi-board Support** — Configure target in `platformio.ini`
- **Library Management** — PlatformIO's built-in library manager
pip install mpremote

```

Then run `mpremote` from your PATH (pipx) or the virtualenv.

## Usage## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

## PlatformIO Workflow

### 1. Configure Your Board

Edit `platformio.ini` to target your board:

**Arduino Uno (AVR):**

```ini
[env:uno]
platform = atmelavr
board = uno
framework = arduino
```

**ESP32:**

```ini
[env:esp32]
platform = espressif32
board = esp32dev
framework = arduino
```

**STM32 Nucleo:**

```ini
[env:nucleo]
platform = ststm32
board = nucleo_f401re
framework = arduino
```

**Raspberry Pi Pico:**

```ini
[env:pico]
platform = raspberrypi
board = pico
framework = arduino
```

### 2. Build and Upload

```bash
# Build
platformio run

# Upload to device
platformio run --target upload

# Monitor serial output
platformio device monitor
```

### 3. Manage Libraries

```bash
# Search for libraries
platformio lib search <query>

# Install library
platformio lib install <library>

# List installed libraries
platformio lib list
```

## Native AVR Compilation (without PlatformIO)

For direct AVR compilation:

```bash
# Compile
avr-g++ -mmcu=atmega328p -DF_CPU=16000000UL -Os -o main.elf main.cpp
avr-objcopy -O ihex -R .eeprom main.elf main.hex

# Flash
avrdude -c arduino -p m328p -P /dev/ttyACM0 -b 115200 -U flash:w:main.hex:i
```

## Multi-Board Projects

Define multiple environments in `platformio.ini`:

```ini
[platformio]
default_envs = uno

[env:uno]
platform = atmelavr
board = uno

[env:esp32]
platform = espressif32
board = esp32dev

[env:pico]
platform = raspberrypi
board = pico
```

Build specific environment:

```bash
platformio run -e esp32
```

## Customization

Edit `flake.nix` to add board-specific tools or adjust C++ compiler settings.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Arduino packaging docs](https://nixos.org/manual/nixpkgs/stable/#arduino) for more details.

## Resources

- [PlatformIO Boards](https://docs.platformio.org/en/latest/boards/index.html)
- [PlatformIO Platforms](https://docs.platformio.org/en/latest/platforms/index.html)
- [Arduino Reference](https://www.arduino.cc/reference/en/)
