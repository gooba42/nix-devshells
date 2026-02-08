# Firmware Management

Both CircuitPython and MicroPython templates now include automated firmware installation.

## Quick Start

### 1. Download Firmware

**CircuitPython:**

```bash
# Visit https://circuitpython.org/downloads
# Download .uf2 for your board
# Save to: circuitpython/firmware/
```

**MicroPython:**

```bash
# Visit https://micropython.org/download
# Download .uf2 (RP2040) or .bin (ESP32) for your board
# Save to: micropython/firmware/
```

### 2. Install Firmware

**CircuitPython:**

```bash
cd circuitpython/
make install-circuitpython
```

**MicroPython:**

```bash
cd micropython/
make install-micropython
# For ESP32: make install-micropython SERIAL_PORT=/dev/ttyUSB0
```

### 3. Verify Installation

```bash
make check-circuitpy    # CircuitPython
make check-micropython  # MicroPython
```

## Makefile Targets

### CircuitPython

- `make check-circuitpy` - Detect CircuitPython and firmware status
- `make install-circuitpython` - Auto-install firmware from firmware/
- `make download-guide` - Show download instructions
- `make flash` - Copy Python code to device
- `make clean` - Clean cache files

### MicroPython

- `make check-micropython` - Detect MicroPython via serial
- `make install-micropython` - Auto-install firmware from firmware/
- `make download-guide` - Show download instructions
- `make flash` - Copy Python code to device (uses mpremote or ampy)
- `make repl` - Connect to REPL console
- `make clean` - Clean cache files

## Firmware Directory Structure

```
circuitpython/
├── firmware/
│   ├── .gitkeep
│   └── circuitpython-pico-en_US-9.0.0.uf2  (your firmware)
└── src/

micropython/
├── firmware/
│   ├── .gitkeep
│   └── rp2-pico-latest.uf2  (your firmware)
└── src/
```

Firmware files are ignored by git but the directory structure is preserved.

## Device Detection

### CircuitPython

- Checks for CIRCUITPY mount (running)
- Checks for RPI-RP2/BOOTSEL mount (bootloader)
- Checks for BOOT mount (Arduino/other firmware)
- Prompts for firmware reinstallation when needed

### MicroPython

- Checks serial port for MicroPython REPL
- Checks for BOOTSEL mount (RP2040 bootloader)
- Supports multiple serial ports via SERIAL_PORT variable
- Auto-detects ESP32/ESP8266 and uses esptool

## Supported Platforms

### CircuitPython

- RP2040 (Pico, Pico W) - UF2
- SAMD21/51 (Metro, Feather) - UF2
- ESP32-S2/S3 - BIN (esptool required)
- nRF52840 - UF2

### MicroPython

- RP2040 (Pico, Pico W) - UF2
- ESP32/ESP8266 - BIN (esptool)
- STM32 - DFU (dfu-util)
- PyBoard - DFU

## Examples

### CircuitPython Workflow

```bash
# Download firmware
wget https://downloads.circuitpython.org/.../firmware.uf2 -P firmware/

# Enter bootloader (hold BOOTSEL, plug USB)
# Install
make install-circuitpython

# Verify
make check-circuitpy

# Deploy code
make flash
```

### MicroPython Workflow (RP2040)

```bash
# Download firmware
wget https://micropython.org/.../rp2-pico.uf2 -P firmware/

# Enter bootloader
make install-micropython

# Verify
make check-micropython

# Deploy code
make flash

# Access REPL
make repl
```

### MicroPython Workflow (ESP32)

```bash
# Download firmware
wget https://micropython.org/.../esp32.bin -P firmware/

# Install (erase + flash)
make install-micropython SERIAL_PORT=/dev/ttyUSB0

# Verify
make check-micropython SERIAL_PORT=/dev/ttyUSB0

# Deploy code
make flash SERIAL_PORT=/dev/ttyUSB0
```
