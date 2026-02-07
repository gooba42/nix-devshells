# MicroPython Development Template

Nix flake template for MicroPython development across ESP32, ESP8266, Raspberry Pi Pico, and STM32 boards.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow

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

- **esptool** — ESP32/ESP8266 flashing
- **picotool** — RP2040 (Pico) operations
- **dfu-util** — STM32 DFU flashing
- **stm32flash** — STM32 serial flashing
- **ampy** — File upload/download
- **mpremote** — Official MicroPython remote control
- **rshell** — Remote shell for MicroPython
- **screen/minicom** — Serial terminals

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
