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
| `picocom` / `minicom` | Serial terminal for REPL |
| `python3` | Python interpreter |
| `pyserial` | Python serial library |
| `pip` | Install CircuitPython libraries |

## Common CircuitPython Libraries

Install these via pip inside the shell:

```bash
# Adafruit tools
pip install adafruit-ampy adafruit-circuitpython-bundle

# Specific device libraries (examples)
pip install adafruit-circuitpython-neopixel
pip install adafruit-circuitpython-dht
pip install adafruit-circuitpython-ads1x15

# Utilities
pip install PySerial
```

Or edit your CircuitPython `boot.py` to include libraries from a `lib/` directory on the Pico.

## Project Structure

```
my-pico-project/
├── src/
│   └── main.py              # Your CircuitPython code
├── lib/                     # CircuitPython libraries (on device)
│   └── (copy .mpy files here)
├── flake.nix               # Nix environment definition
├── .envrc                  # direnv setup
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
