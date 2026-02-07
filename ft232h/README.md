# FT232H Blinka Flake (USB → I2C/SPI/GPIO)

Find the latest version of this template at:
<https://github.com/gooba42/nixos-ng/tree/master/flakes/ft232h>

Nix-based dev environment for the Adafruit FT232H breakout. Lets you use CircuitPython **Blinka** libraries on any computer to talk I2C/SPI/GPIO over USB.

## What this gives you

- Cross-platform dev shell (Linux/macOS/Windows via WSL)
- Python 3 + `pyftdi` + `adafruit-blinka` (install into `.venv`)
- libusb + libftdi1
- Env var `BLINKA_FT232H=1` pre-set
- Helpers: I2C scan, GPIO toggle, serial terminals

## Quick start

```bash
nix develop                 # enter the dev environment
make venv install           # create .venv and pip install deps
make scan-i2c               # example: I2C bus scan
make gpio                   # example: toggle GPIO pin
```

**Important:** You must run `nix develop` first. All make targets require Python, which is only available inside the nix shell.

## Linux udev rule (needed for permissions)

```bash
sudo tee /etc/udev/rules.d/11-ftdi.rules >/dev/null <<'RULES'
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", GROUP="plugdev", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6011", GROUP="plugdev", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", GROUP="plugdev", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", GROUP="plugdev", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6015", GROUP="plugdev", MODE="0666"
RULES
sudo udevadm control --reload-rules && sudo udevadm trigger
# replug the FT232H
```

If you prefer stricter permissions, replace `MODE="0666"` with `MODE="0660" GROUP="plugdev"` and ensure your user is in `plugdev`.

## Virtual environment workflow

```bash
nix develop
make venv        # python -m venv .venv
make install     # pip install -r requirements.txt
source .venv/bin/activate
python src/scan_i2c.py
```

## Requirements installed in `.venv`

- `adafruit-blinka`
- `pyftdi`
- `adafruit-circuitpython-busdevice`
- `numpy` (pyftdi extra)

## Environment variables

- `BLINKA_FT232H=1` (set in devShell and scripts; required by Blinka)
- `BLINKA_SUPPRESS_INVALID_CHIP_DETECT=1` (set in example scripts; suppresses warnings when no FT232H is connected during development)

## Testing without an FT232H device

The example scripts (`src/scan_i2c.py` and `src/gpio_blink.py`) set `BLINKA_SUPPRESS_INVALID_CHIP_DETECT=1` to gracefully handle the case where no physical FT232H device is present. This allows you to:

- Test the development environment setup
- Verify dependencies are installed correctly
- Debug code logic without hardware

When you run a script without a connected FT232H, it will catch the error and display a helpful message indicating that the device is not connected. This is **normal and expected** during initial development.

**To actually communicate with I2C/SPI/GPIO devices**, you must:

1. Connect an Adafruit FT232H breakout via USB
2. Install the udev rules (see Linux udev rule section above)
3. Ensure your user is in the `plugdev` group
4. Run the script again

## Example scripts

- `src/scan_i2c.py` — scans the I2C bus for devices
- `src/gpio_blink.py` — toggles D0 every second

## Handy commands

```bash
make detect        # list USB devices (lsusb) and FTDI IDs
make scan-i2c      # run I2C scan example
make gpio          # run GPIO toggle example
make shell         # enter venv shell (if already created)
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Python packaging docs](https://nixos.org/manual/nixpkgs/stable/#python) for more details.

## References

- [Adafruit guide](https://learn.adafruit.com/circuitpython-on-any-computer-with-ft232h)
- [pyftdi install notes](https://github.com/eblot/pyftdi/blob/master/pyftdi/doc/installation.rst)
- [Adafruit Blinka](https://github.com/adafruit/Adafruit_Blinka)
