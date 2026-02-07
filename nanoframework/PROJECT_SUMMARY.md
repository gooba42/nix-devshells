# .NET nanoFramework Nix Flake - Project Summary

## ✅ What You Have

A complete, cross-platform embedded .NET development environment for your microcontrollers:

```
nanoframework/
├── flake.nix                    # Nix environment with all tooling
├── .envrc                       # direnv auto-loader (optional)
├── NanoFrameworkApp.csproj      # C# project file
├── src/Program.cs               # Example: GPIO LED blink
├── scripts/
│   ├── detect-devices.sh        # Find connected boards
│   ├── flash-esp.sh             # Flash ESP32/ESP8266
│   ├── flash-pico.sh            # Flash RP Pico
│   ├── flash-stm32.sh           # Flash STM32 boards
│   └── monitor-serial.sh        # Serial REPL monitor
├── Makefile                     # Convenient build & flash targets
├── README.md                    # Full documentation
├── QUICKSTART.md                # Your hardware guide
└── .gitignore                   # Git configuration
```

## 🎯 Your Hardware Support

| Hardware | Status | Notes |
|----------|--------|-------|
| **ESP32** | ✅ Full | Serial flashing via `nanoff` |
| **ESP8266** | ✅ Full | Serial flashing via `nanoff` |
| **RP Pico** | ✅ Full | DFU mode flashing |
| **Arduino** | ⚠️ Limited | Basic GPIO only (ATmega only) |

## 🚀 Getting Started in 3 Steps

### 1. Enter Development Environment

```bash
cd /home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework
nix develop
```

**What this loads:**

- .NET SDK 8
- Mono (for build tools on Linux/macOS)
- `nanoff` (firmware flasher)
- All device flashing tools (esptool, dfu-util, picotool, etc.)
- Serial monitoring (screen, minicom, picocom)

### 2. Detect Your Device

```bash
make detect
# or
nanoff --listports
```

### 3. Flash & Monitor

```bash
# For ESP32:
make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0

# Monitor output:
make monitor PORT=/dev/ttyUSB0
```

## 📋 Available Commands

| Command | Purpose |
|---------|---------|
| `make build` | Build the C# project |
| `make clean` | Clean build artifacts |
| `make detect` | List connected devices |
| `make monitor PORT=/dev/ttyUSB0` | Serial monitor |
| `make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0` | Flash ESP |
| `make flash-pico` | Flash RP Pico (DFU) |
| `make flash-stm32 TARGET=ST_NUCLEO144_F746ZG` | Flash STM32 |

## 🔧 Key Features

✅ **Cross-platform**: Linux, macOS, Windows
✅ **Multi-board support**: ESP32, ESP8266, RP Pico, STM32, Arduino
✅ **Unified tooling**: Single flake for all platforms
✅ **Debugging**: VS Code extension support
✅ **Scripts**: Helper scripts for common tasks
✅ **Documentation**: README + QUICKSTART guides

## 📂 File Descriptions

### `flake.nix`

Nix environment definition. Contains:

- All required packages (.NET SDK, Mono, flashing tools)
- `devShells.default` - The development environment
- Shell hook with helpful initialization messages
- Helper script package

### `NanoFrameworkApp.csproj`

C# project file with NuGet dependencies for GPIO, I2C, SPI, etc.

### `src/Program.cs`

Example C# code: LED blinking on GPIO pin 2. Modify for your use case.

### `Makefile`

Convenience targets for build, flash, detect, monitor.

### `scripts/*.sh`

Helper Bash scripts:

- **detect-devices.sh** - Lists serial ports, USB devices, DFU devices
- **flash-esp.sh** - Flashes ESP32/ESP8266 with nanoff
- **flash-pico.sh** - Flashes RP Pico via DFU
- **flash-stm32.sh** - Flashes STM32 boards
- **monitor-serial.sh** - Opens serial monitor with screen/minicom

### `QUICKSTART.md`

**👉 Start here!** Hardware-specific setup guide for your boards.

### `README.md`

Comprehensive documentation covering all platforms and features.

## 🎓 What to Explore Next

1. **Hardware examples**: Check each script for board-specific commands
2. **NuGet packages**: Browse available nanoFramework NuGet packages
3. **Samples**: Clone <https://github.com/nanoframework/Samples> for real projects
4. **API docs**: <https://docs.nanoframework.net/api/index.html>
5. **VS Code extension**: Install for live debugging support

## 🔌 Hardware Setup Tips

### ESP32/ESP8266

- Use USB-to-UART converter (usually CH340 or CP2102)
- Linux: Install CH340 driver if needed
- Windows: May need driver from Silicon Labs
- Port is typically `/dev/ttyUSB0` (Linux) or `COM3`+

### RP Pico

- **No drivers needed!** Uses native USB
- **DFU mode**: Hold BOOTSEL while connecting USB
- Built-in LED on GPIO 25 (try that first)
- Great learning platform (RP2040 chip)

### Arduino

- Limited .NET nanoFramework support (ATmega328p only)
- Better: Get an ESP32 (same cost, 1000x more powerful)

## 🆘 Troubleshooting

**Device not showing up?**

```bash
make detect
lsusb          # Check for USB devices
sudo usermod -a -G dialout $USER  # Fix permissions on Linux
```

**nanoff not found?**

```bash
nix develop    # Make sure you're in the nix shell
which nanoff   # Verify
```

**Build fails?**

```bash
dotnet clean
dotnet restore
dotnet build
```

**Serial monitor won't open?**

```bash
ls -la /dev/tty*        # Check port exists
screen /dev/ttyUSB0 115200  # Or: minicom -D /dev/ttyUSB0 -b 115200
```

## 📚 Resources

- **Official Docs**: <https://docs.nanoframework.net>
- **GitHub**: <https://github.com/nanoframework>
- **Samples**: <https://github.com/nanoframework/Samples>
- **Discord**: <https://discord.gg/gCyBu8T>
- **NuGet**: <https://www.nuget.org/profiles/nanoframework>

## 🤝 Integration with Your Nix Project

This flake is located at:

```
/home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework/
```

You can use it as a template:

```bash
nix flake init -t path:/home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework
```

Or reference it from other projects:

```nix
# In another flake.nix:
inputs.nanoframework.url = "path:../nanoframework";
```

## ✨ Next Steps

1. ✅ Read `QUICKSTART.md` for your specific hardware
2. ✅ Run `nix develop` and `make detect`
3. ✅ Flash firmware to one of your boards
4. ✅ Monitor output and verify it works
5. ✅ Modify the example code for GPIO control
6. ✅ Explore I2C, SPI, ADC, PWM examples
7. ✅ Build something cool!

---

**Enjoy embedded .NET development with nanoFramework! 🚀**

Questions? Check the resources above or ask in the [nanoFramework Discord](https://discord.gg/gCyBu8T).
