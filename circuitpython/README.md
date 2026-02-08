# CircuitPython Flake: Multi-Board Development

This flake provides a complete Nix-based development environment for CircuitPython on multiple microcontroller platforms.

## Supported Boards

| Platform | Examples | Flashing Method |
|----------|----------|-----------------|
| **RP2040** | Raspberry Pi Pico, Pico W, Adafruit Feather RP2040 | UF2 drag-and-drop |
| **ESP32-S2/S3** | Adafruit Feather ESP32-S2/S3, ESP32-S3 DevKit | esptool (serial) |
| **SAMD21/51** | Adafruit Metro M0/M4, Feather M0/M4, ItsyBitsy | UF2 or bossac |
| **nRF52840** | Adafruit Feather nRF52840 | UF2 drag-and-drop |
| **STM32F4** | Various STM32F4 Discovery boards | dfu-util |

## Features

- **Python 3.11+** development environment
- **Multi-board tools**: picotool, esptool, bossac, dfu-util, openocd
- **Serial Communication**: pyserial, screen for REPL access
- **File Transfer**: ampy for uploading code to devices
- **Reproducible**: Locked flake.lock ensures identical environments

## Quick Start

### 1. Create a new CircuitPython project

```bash
mkdir ~/my-circuitpython-project && cd ~/my-circuitpython-project
nix flake init -t /home/gooba42/nixos/flakes#circuitpython
direnv allow
```

### 2. Flash CircuitPython Firmware

Download firmware from [circuitpython.org](https://circuitpython.org/downloads) for your board.

**RP2040 (Pico, Pico W):**

```bash
# Hold BOOTSEL button and plug in board
# Copy UF2 file to mounted drive
cp circuitpython-<version>.uf2 /media/$USER/RPI-RP2/
```

**ESP32-S2/S3:**

```bash
# Flash using esptool
esptool.py --port /dev/ttyUSB0 write_flash 0x0 circuitpython-<version>.bin
```

**SAMD21/51:**

```bash
# Double-tap reset button for UF2 bootloader
cp circuitpython-<version>.uf2 /media/$USER/<BOARD_NAME>/
# Or use bossac:
bossac -e -w -v -R --port=/dev/ttyACM0 circuitpython-<version>.bin
```

**nRF52840:**

```bash
# Double-tap reset for UF2 bootloader
cp circuitpython-<version>.uf2 /media/$USER/<BOARD_NAME>/
```

### 3. Access the REPL

Once CircuitPython is running:

```bash
# Find your serial device
ls /dev/ttyACM*

# Connect to REPL (Ctrl-A then Ctrl-\ to exit screen)
screen /dev/ttyACM0 115200
```

### 4. Write code and deploy

Create your CircuitPython code in `src/main.py`:

```python
import board
import digitalio
import time

led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT

while True:
    led.value = True
    time.sleep(0.5)
    led.value = False
    time.sleep(0.5)
```

Deploy using adafruit-ampy:

```bash
# Install adafruit-ampy (first time only)
pip install adafruit-ampy

# Copy files to Pico
ampy --port /dev/ttyACM0 put src/main.py main.py
```

## Available Tools

| Tool | Purpose |
|------|---------|
| `picotool` | Manage Pico firmware and read/write |
| `openocd` | Debug via SWD/JTAG interface |
| `screen` / `socat` | Serial terminal for REPL |
| `python3` | Python interpreter |
| `pyserial` | Python serial library |
| `pip` | Install CircuitPython libraries |
| `ampy` | Upload files to CircuitPython devices |
| `mpremote` | Modern MicroPython/CircuitPython device interaction |
| `circup` | CircuitPython library updater |
| `pytest` | Test CircuitPython code locally |

## CircuitPython Library Bundle

### Automated Bundle Download

The easiest way to get all Adafruit CircuitPython libraries is using the automated bundle downloader:

```bash
nix run .#fetch-bundle
```

This command:

1. Downloads the latest [Adafruit CircuitPython Bundle](https://github.com/adafruit/Adafruit_CircuitPython_Bundle/releases/latest) from GitHub
2. Extracts it to `./circuitpython-bundle/`
3. Shows available libraries and next steps

**Specify a custom location:**

```bash
nix run .#fetch-bundle -- /path/to/location
# Creates /path/to/location/circuitpython-bundle/
```

**Using libraries from the bundle:**

After downloading, copy libraries to your project:

```bash
# Copy specific libraries to your project
cp -r circuitpython-bundle/libraries/Adafruit_CircuitPython_NeoPixel src/lib/
cp -r circuitpython-bundle/libraries/Adafruit_CircuitPython_DHT src/lib/

# Or upload directly to device
ampy --port /dev/ttyACM0 put circuitpython-bundle/libraries/Adafruit_CircuitPython_NeoPixel lib/
```

### Manual Installation

You can also install libraries individually via pip:

```bash
# Adafruit tools
pip install adafruit-ampy

# Specific device libraries (examples)
pip install adafruit-circuitpython-neopixel
pip install adafruit-circuitpython-dht
pip install adafruit-circuitpython-ads1x15

# Utilities
pip install PySerial
```

Or edit your CircuitPython `boot.py` to include libraries from a `lib/` directory on the device.

## Makefile Targets

This template includes helpful Make targets for firmware installation and device management:

### Device Detection & Setup

**`make detect-board`**

Auto-detects connected board via USB and provides direct download link to firmware:

```bash
make detect-board
# Output example:
# ✓ Detected: Raspberry Pi Pico (RP2040)
# Download: https://circuitpython.org/board/raspberry_pi_pico/
```

Supports automatic detection for:

- Raspberry Pi Pico, Pico W (RP2040)
- Adafruit boards (Feather, Metro, ItsyBitsy series)
- ESP32-S2/S3 boards

**`make check-circuitpy`**

Verifies CircuitPython installation status and shows firmware version:

```bash
make check-circuitpy
# ✓ CircuitPython detected at /media/user/CIRCUITPY
# ✓ Firmware info:
# Adafruit CircuitPython 8.2.10 on 2024-01-16; Raspberry Pi Pico with rp2040
```

### Firmware Installation

**`make download-guide`**

Shows step-by-step instructions for downloading CircuitPython firmware:

```bash
make download-guide
```

**`make install-circuitpython`**

Automatically flashes firmware from the `firmware/` directory to your device (when in bootloader mode):

```bash
# 1. Put device in BOOTSEL mode (hold BOOTSEL button while plugging in USB)
# 2. Download firmware to firmware/ directory
# 3. Run:
make install-circuitpython
```

Supports:

- UF2 files (RP2040, SAMD, nRF52)
- BIN files (ESP32-S2/S3)
- Multiple board types with automatic format detection

### Code Deployment

**`make flash`**

Copies Python files from `src/` directory to the CIRCUITPY device:

```bash
make flash
# Copies src/*.py to CIRCUITPY drive
```

Automatically re-runs your code when finished.

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
make install-circuitpython     # Flash CircuitPython firmware
make check-circuitpy           # Verify CircuitPython is installed
make flash                     # Deploy code to device
make clean                     # Remove cache files
```

## Nix App Targets

Beyond Make, the template provides Nix app targets for common operations:

**`nix run .#fetch-bundle`**

Download the latest CircuitPython library bundle from GitHub (see [CircuitPython Library Bundle](#circuitpython-library-bundle) section)

**`nix run .#flash`**

Flash CircuitPython UF2 firmware to RP2040 device (set `UF2=/path/to/firmware.uf2` environment variable)

**`nix run .#copy-usb`**

Copy files to RP2040 BOOTSEL drive for boards that mount as USB storage

## Project Structure

```
my-pico-project/
├── src/
│   └── main.py              # Your CircuitPython code
├── lib/                     # CircuitPython libraries (on device)
│   └── (copy .mpy files here)
├── firmware/                # CircuitPython firmware files for flashing
│   └── (download .uf2 or .bin files here)
├── tests/                   # pytest test files
│   └── test_main.py
├── flake.nix               # Nix environment definition
├── .envrc                  # direnv setup
├── Makefile                # Device management targets
└── .gitignore              # Git ignore rules
```

## Debugging with openocd

To debug via SWD (Serial Wire Debug), you'll need a compatible debugger (e.g., Picoprobe or another Pico).

```bash
openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg
```

Then use gdb to connect:

```bash
gdb
> target remote localhost:3333
> load
> break main
> continue
```

## Local Testing with pytest

Test your CircuitPython code locally without hardware using pytest and mocking:

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src tests/

# Run specific test file
pytest tests/test_main.py -v
```

**Example test file** (`tests/test_main.py`):

```python
import pytest
from unittest.mock import Mock, MagicMock, patch

# Mock board and digitalio modules
@pytest.fixture
def mock_board():
    board = MagicMock()
    board.LED = Mock()
    return board

def test_led_blink(mock_board):
    """Test LED blink logic without hardware"""
    with patch('board.board', mock_board):
        # Your test code here
        assert mock_board.LED is not None
```

Use `pytest-mock` to easily create hardware mocks for testing sensor reads, GPIO operations, and I2C/SPI communication.

## Tips & Tricks

### Auto-reload on save

The Pico has auto-reload when `main.py` or `boot.py` changes. Just save with `ampy`:

```bash
ampy --port /dev/ttyACM0 put src/main.py main.py
```

### Monitor REPL output

```bash
picocom /dev/ttyACM0 -b 115200 -c
# Scroll up to see previous output with -c flag
```

### Multiple Picos

If you have multiple Picos connected, use specific ports:

```bash
ls /dev/ttyACM*  # List all connected
ampy --port /dev/ttyACM1 put src/main.py main.py
```

## Resources

- **Official CircuitPython Docs**: <https://docs.circuitpython.org/>
- **Pico Getting Started**: <https://www.raspberrypi.com/documentation/microcontrollers/pico-series.html>
- **Adafruit CircuitPython Bundles**: <https://github.com/adafruit/circuitpython-stubs>
- **CircuitPython GitHub**: <https://github.com/adafruit/circuitpython>

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Python packaging docs](https://nixos.org/manual/nixpkgs/stable/#python) for more details.

---

**Happy Pico hacking!**
