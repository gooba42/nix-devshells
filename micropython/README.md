# MicroPython Development Template

Nix flake template for MicroPython development across ESP32, ESP8266, Raspberry Pi Pico, and STM32 boards.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **Python Virtual Environment**: Creates and activates `.venv/` for isolated pip packages
✓ **Tools Installation**: Installs `adafruit-ampy`, `mpremote`, and `rshell` via pip
✓ **Environment Banner**: Displays available tools and quick-start commands

No manual setup needed! Just start coding.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs MicroPython packaging docs](https://nixos.org/manual/nixpkgs/stable/#python) for more details.

## Supported Boards

| Platform | Chip | Flashing Tool |
|----------|------|---------------|
| ESP32 | ESP32, ESP32-S2/S3, ESP32-C3 | esptool |
| ESP8266 | ESP8266 | esptool |
| Raspberry Pi Pico | RP2040 | picotool / UF2 |
| STM32 | Various STM32 | dfu-util / stm32flash |
| PyBoard | STM32F4 | dfu-util |

## Workflow

### 1. Download Firmware

Get MicroPython firmware from [micropython.org/download](https://micropython.org/download)

### 2. Flash Firmware

**ESP32/ESP8266:**

```bash
esptool.py --chip esp32 --port /dev/ttyUSB0 write_flash -z 0x1000 esp32-firmware.bin
```

**Raspberry Pi Pico (UF2):**

```bash
# Hold BOOTSEL, plug in, copy file:
cp rp2-pico-firmware.uf2 /media/$USER/RPI-RP2/
```

**Raspberry Pi Pico (picotool):**

```bash
picotool load rp2-pico-firmware.uf2
picotool reboot
```

**STM32 (DFU mode):**

```bash
dfu-util -a 0 -d 0483:df11 -D stm32-firmware.dfu
```

### 3. Upload Code

Create `src/main.py` with your code:

```python
import time
from machine import Pin

led = Pin(2, Pin.OUT)  # GPIO2 on ESP32, Pin 25 on Pico

while True:
    led.on()
    time.sleep(0.5)
    led.off()
    time.sleep(0.5)
```

Upload using ampy:

```bash
ampy --port /dev/ttyUSB0 put src/main.py
```

Or using mpremote:

```bash
mpremote connect /dev/ttyUSB0 cp src/main.py :main.py
```

### 4. Access REPL

**Using screen:**

```bash
screen /dev/ttyUSB0 115200
# Ctrl-A then Ctrl-\ to exit
```

**Using mpremote:**

```bash
mpremote connect /dev/ttyUSB0 repl
```

**Using rshell:**

```bash
rshell --port /dev/ttyUSB0
```

## Included Tools

| Tool | Purpose |
|------|---------|
| **esptool** | ESP32/ESP8266 firmware flashing |
| **picotool** | RP2040 (Pico) firmware operations |
| **dfu-util** | STM32 DFU bootloader flashing |
| **stm32flash** | STM32 serial port flashing |
| **openocd** | JTAG/SWD debugging for STM32 and ARM boards |
| **cmake** | Build system for building MicroPython from source |
| **gcc/gnumake** | C compiler and build tools |
| **git** | Version control (auto-initialized in devShell) |
| **black** | Python code formatter |

## Python Tools (in .venv)

The environment automatically includes via pip:

| Tool | Purpose |
|------|---------|
| **ampy** | File transfer and REPL over serial |
| **mpremote** | Official MicroPython device control and REPL |
| **rshell** | Remote shell for file operations on device |

## Testing & Development Features

The devShell includes comprehensive testing tools:

- **pytest** (8.4.2) - Framework for writing and running tests
- **pytest-mock** (3.15.1) - Mock library for hardware simulation
- **pytest-cov** (6.2.1) - Code coverage reporting
- **adafruit-platformdetect** - Platform detection for board identification
- **adafruit-pureio** - Hardware abstraction for testing without devices

**Example usage:**

```bash
# Run all tests
pytest

# Run with coverage report
pytest --cov=src tests/

# Run specific test
pytest tests/test_main.py -v
```

Use these to test MicroPython code locally before deploying to hardware.

## Makefile Targets

This template includes helpful Make targets for firmware installation and device management:

### Device Detection & Setup

**`make detect-board`**

Auto-detects connected board via USB and provides direct download link to firmware:

```bash
make detect-board
# Output example:
# ✓ Detected: Raspberry Pi Pico (RP2040)
# Download: https://micropython.org/download/rp2-pico/
```

Supports automatic detection for:

- Raspberry Pi Pico (RP2040)
- Adafruit boards
- ESP32 and ESP32-S2/S3
- STM32 boards

**`make check-micropython`**

Verifies MicroPython installation status via serial connection:

```bash
make check-micropython
# ✓ Serial device detected: /dev/ttyUSB0
# ✓ MicroPython is running!
```

Set custom serial port: `make check-micropython SERIAL_PORT=/dev/ttyACM0`

### Firmware Installation

**`make download-guide`**

Shows step-by-step instructions for downloading MicroPython firmware:

```bash
make download-guide
```

**`make install-micropython`**

Automatically flashes firmware from the `firmware/` directory to your device (when in bootloader mode):

```bash
# 1. Put device in bootloader mode
# 2. Download firmware to firmware/ directory
# 3. Run:
make install-micropython
```

Supports multiple firmware formats:

- UF2 files (RP2040)
- BIN files (ESP32, ESP8266)
- HEX files (STM32)
- DFU files (STM32)

### Code Deployment

**`make flash`**

Copies Python files from `src/` directory to the device via ampy:

```bash
make flash
# Copies src/*.py to device
```

Set custom serial port: `make flash SERIAL_PORT=/dev/ttyACM0`

**`make repl`**

Opens interactive REPL (Read-Eval-Print Loop) using screen:

```bash
make repl
# Ctrl-A then Ctrl-\ to exit
```

Set custom serial port: `make repl SERIAL_PORT=/dev/ttyACM0`

**`make clean`**

Removes Python cache files:

```bash
make clean
# Removes *.pyc and __pycache__ directories
```

### Quick Reference

```bash
make help                      # Show all available targets
make detect-board              # Identify connected board
make download-guide            # Show firmware download instructions
make install-micropython       # Flash MicroPython firmware
make check-micropython         # Verify MicroPython is installed
make flash SERIAL_PORT=/dev/ttyUSB0  # Deploy code to device
make repl SERIAL_PORT=/dev/ttyUSB0   # Open REPL
make clean                     # Remove cache files
```

## Device Detection

```bash
# Find serial ports
ls /dev/tty{USB,ACM}*

# Check USB devices
lsusb
```

## Common Tasks

**List files on device:**

```bash
mpremote fs ls
```

**Download file from device:**

```bash
ampy --port /dev/ttyUSB0 get boot.py
```

**Run script without uploading:**

```bash
mpremote run src/test.py
```

## Customization

Edit `flake.nix` to add board-specific tools or adjust Python packages.

## Resources

- [MicroPython Documentation](https://docs.micropython.org/)
- [MicroPython Downloads](https://micropython.org/download/)
- [Quick Reference](https://docs.micropython.org/en/latest/reference/index.html)
