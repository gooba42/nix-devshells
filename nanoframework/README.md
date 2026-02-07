# .NET nanoFramework Flake

A Nix-flake-based development environment for cross-platform embedded C# development using .NET nanoFramework.

## Overview

[.NET nanoFramework](https://nanoframework.net/) enables C# developers to write managed code applications for embedded microcontrollers. This flake provides a complete dev environment with:

- **Cross-platform support**: Linux, macOS, Windows
- **Multi-board support**: ESP32, ESP8266, RP Pico, STM32, Arduino
- **Live debugging**: (VS Code extension)
- **Unified tooling**: `nanoff` firmware flasher, all flashing utilities, serial monitors

## Supported Boards

| Board | Platform | Flashing Method | Status |
|-------|----------|-----------------|--------|
| ESP32 | Espressif | Serial (USB-to-UART) | ✅ Fully supported |
| ESP8266 | Espressif | Serial (USB-to-UART) | ✅ Fully supported |
| RP Pico | Raspberry Pi | DFU / Serial | ✅ Fully supported |
| STM32 Nucleo/Discovery | ST Microelectronics | ST-Link / DFU | ✅ Fully supported |
| Arduino-compatible | Various | Serial | ✅ Compatible |

## Quick Start

### 1. Enter Development Environment

```bash
cd nanoframework
nix develop
```

This loads:

- .NET SDK 8
- Mono (build tools)
- nanoff (firmware flasher)
- All flashing utilities (esptool, dfu-util, picotool, etc.)
- Serial monitoring tools (screen, minicom)

### 2. Build Your Project

```bash
dotnet build
```

### 3. Detect Connected Device

```bash
nanoff --listports
```

Output example:

```
COM ports:
  /dev/ttyUSB0
```

### 4. Flash Device with Latest Firmware

#### ESP32

```bash
nanoff --platform esp32 --serialport /dev/ttyUSB0 --update
```

#### ESP8266

```bash
nanoff --platform esp8266 --serialport /dev/ttyUSB0 --update
```

#### RP Pico (DFU mode)

Hold BOOTSEL button while connecting USB, then:

```bash
nanoff --target RP2040_NANO --update --dfu
```

#### STM32 Nucleo (ST-Link)

```bash
nanoff --target ST_NUCLEO144_F746ZG --update
```

#### STM32 Nucleo (DFU mode)

Put board in DFU mode (see board docs), then:

```bash
nanoff --target ST_NUCLEO144_F746ZG --update --dfu
```

### 5. Deploy & Debug

For VS Code live debugging (requires [VS Code Extension](https://docs.nanoframework.net/content/getting-started-guides/getting-started-vs-code.html)):

```bash
code .
# Install nanoFramework extension, then:
# Command: nanoFramework: Deploy Project
```

For serial REPL/debugging:

```bash
screen /dev/ttyUSB0 115200
# Press Ctrl+A then Ctrl+Q to exit
```

## Device Files in Project

- `NanoFrameworkApp.csproj` — C# project file with NuGet references
- `src/Program.cs` — Example LED blink code
- `flake.nix` — Nix flake definition
- `.envrc` — direnv integration (if using `direnv`)

## Example: GPIO (LED Blink)

The included `src/Program.cs` demonstrates GPIO:

```csharp
using System;
using System.Threading;
using System.Device.Gpio;

public class Program
{
    private const int LED_PIN = 2; // Adjust for your board
    
    public static void Main()
    {
        GpioController gpio = new GpioController();
        gpio.OpenPin(LED_PIN, PinMode.Output);
        
        while (true)
        {
            gpio.Write(LED_PIN, PinValue.High);
            Thread.Sleep(1000);
            gpio.Write(LED_PIN, PinValue.Low);
            Thread.Sleep(1000);
        }
    }
}
```

**Pin references by board:**

- **ESP32**: GPIO 2 (with built-in LED typically on 25, 26, 27)
- **ESP8266**: GPIO 2 / D4
- **RP Pico**: GPIO 25 (LED on board)
- **STM32 Nucleo F746ZG**: LD1 on board (check schematics)

## Common Tasks

### List All Available Targets

```bash
nanoff --listboards
```

### Build & Deploy (IDE Integration)

With [VS Code Extension](https://docs.nanoframework.net/content/getting-started-guides/getting-started-vs-code.html):

1. Install extension: `nanoframework.nanoFramework-VS-Code-Extension`
2. Open command palette: `Ctrl+Shift+P`
3. Run: **nanoFramework: Flash device**
4. Run: **nanoFramework: Deploy Project**

### Serial Monitoring

Monitor device output in real-time:

```bash
# Option 1: GNU screen (recommended)
screen /dev/ttyUSB0 115200

# Option 2: minicom
minicom -D /dev/ttyUSB0 -b 115200

# Option 3: picocom
picocom -b 115200 /dev/ttyUSB0
```

Exit with `Ctrl+A Q` (screen) or `Ctrl+X` (minicom/picocom).

### Troubleshooting Device Detection

**Windows permissions:**

```bash
# Grant USB permissions (Linux)
sudo usermod -a -G dialout $USER
# Then logout and login
```

**Check USB devices:**

```bash
lsusb
```

**Check serial ports:**

```bash
ls -la /dev/ttyUSB*
ls -la /dev/ttyACM*  # Arduino-style
```

## Flashing with Alternative Tools

You can also use lower-level tools directly:

### ESP32/ESP8266 (esptool)

```bash
esptool.py --chip esp32 --port /dev/ttyUSB0 erase_flash
esptool.py --chip esp32 --port /dev/ttyUSB0 write_flash 0x1000 nanofw.bin
```

### RP Pico (DFU)

```bash
dfu-util -l  # List devices
dfu-util -D firmware.uf2 -a 0  # Flash
```

### STM32 (STM32CubeProgrammer)

```bash
stm32cubeprog -c port=SWD -d nanofw.bin
```

## Project Structure

```
nanoframework/
├── flake.nix                    # Nix environment definition
├── .envrc                       # direnv config (if used)
├── NanoFrameworkApp.csproj      # C# project file
├── src/
│   └── Program.cs               # Example application
└── README.md                    # This file
```

## Resources

- **Official Docs**: <https://docs.nanoframework.net>
- **GitHub**: <https://github.com/nanoframework>
- **Samples**: <https://github.com/nanoframework/Samples>
- **NuGet Packages**: <https://www.nuget.org/profiles/nanoframework>
- **Discord Community**: <https://discord.gg/gCyBu8T>
- **Board Support Matrix**: <https://github.com/nanoframework/Home#firmware-for-reference-boards>

## API Documentation

Common namespaces available:

- `System.Device.Gpio` — GPIO pins
- `System.Device.I2c` — I2C protocol
- `System.Device.Spi` — SPI protocol
- `System.Device.Pwm` — PWM signals
- `System.Device.Adc` — Analog inputs
- `Windows.Devices.SerialCommunication` — UART/Serial
- `System.Net` — Networking (WiFi/Ethernet)

## VS Code Integration

### Install Extension

1. Open Extensions: `Ctrl+Shift+X`
2. Search: `nanoframework`
3. Install: **nanoFramework** (by nanoframework.net)

### Commands Available

- `nanoFramework: Flash device`
- `nanoFramework: Build Project`
- `nanoFramework: Deploy Project`
- `nanoFramework: Show Device Explorer`

### Live Debugging

Connect to device, set breakpoints, and debug live C# code—unique to nanoFramework!

## Platform-Specific Notes

### ESP32 / ESP8266

- Use `nanoff` for firmware updates
- Serial port is typically `/dev/ttyUSB0` on Linux
- May require USB driver installation (CH340/CP2102)
- Built-in WiFi available via `System.Net.NetworkInformation`

### RP Pico

- Supports both DFU and Serial deployment
- Board has built-in LED on GPIO 25
- Excellent for learning (low cost, great community)
- Great for IoT projects

### STM32 Nucleo / Discovery

- ST-Link debugger built-in (black connector)
- Supports live JTAG debugging
- Wide range of board options (F4, F7, H7 series)
- Professional-grade tools available

### Arduino-Compatible

- Limited resource boards (less RAM/Flash)
- Supported for basic GPIO/Serial projects
- Classic development experience

## Building Custom Firmware

For advanced users who want to modify the nanoFramework core:

- **Firmware source**: <https://github.com/nanoframework/nf-interpreter>
- **Build instructions**: <https://docs.nanoframework.net/content/building/index.html>
- Requires CMake, GCC toolchains, and significant build time

For most users, `nanoff` pre-built firmware is sufficient.

## direnv (Optional)

If you use [direnv](https://direnv.net/):

```bash
direnv allow
```

This auto-loads the Nix shell when entering this directory.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs .NET packaging docs](https://nixos.org/manual/nixpkgs/stable/#dotnet) for more details.

## License

.NET nanoFramework is free and open-source under the Apache 2.0 license.

---

**Happy embedded development!** 🚀

For issues or questions, visit the [nanoFramework Discord](https://discord.gg/gCyBu8T) or [GitHub Issues](https://github.com/nanoframework/nanoframework.github.io/issues).
