# Getting Started with Your Hardware

This guide covers setup for the boards you have: **Arduino, RP Pico, ESP8266, and ESP32**.

## Quick Reference

| Your Hardware | Platform | Port | Flash Command |
|---|---|---|---|
| ESP32 | Espressif | `/dev/ttyUSB0` | `make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0` |
| ESP8266 | Espressif | `/dev/ttyUSB0` | `make flash-esp PLATFORM=esp8266 PORT=/dev/ttyUSB0` |
| RP Pico | Raspberry Pi | DFU | `make flash-pico` |
| Arduino | Various | `/dev/ttyACM0` | Limited support (basic GPIO only) |

## Step 1: Detect Your Device

```bash
nix develop
make detect
```

This shows all connected serial ports and USB devices.

### Expected Output Examples

**ESP32/ESP8266 (UART):**

```
Serial Ports:
  /dev/ttyUSB0
```

**RP Pico (DFU mode):**

1. Hold **BOOTSEL** button on board
2. While holding, connect USB to computer
3. Release **BOOTSEL**

Then run:

```bash
dfu-util -l
```

Should show:

```
Found DFU: [xxxx:xxxx] ver=..., devnum=..., cfg=..., intf=..., path="...", alt=..., name="..." serial="..."
```

## Step 2: Build Your Project

```bash
make build
```

This compiles the example C# blink project.

## Step 3: Flash Firmware to Your Board

### ESP32

```bash
make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0
```

**Troubleshooting:**

- Board not detected? Check USB cable and drivers
- Windows: May need [CH340 driver](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers)
- Linux: `sudo usermod -a -G dialout $USER` (logout/login)

### ESP8266

```bash
make flash-esp PLATFORM=esp8266 PORT=/dev/ttyUSB0
```

Same drivers as ESP32.

### RP Pico

```bash
# Step 1: Put into DFU mode
# Hold BOOTSEL button, connect USB, release BOOTSEL

# Step 2: Flash
make flash-pico
```

The board appears as USB mass storage or DFU device—no drivers needed (usually).

### Arduino (Limited)

.NET nanoFramework has **limited support** for classic Arduino boards (ATmega328p). Check [compatibility list](https://github.com/nanoframework/Home#firmware-for-reference-boards).

For Arduino Uno/Nano:

```bash
nanoff --listboards | grep -i arduino
nanoff --target YOUR_BOARD_NAME --serialport /dev/ttyACM0 --update
```

## Step 4: Monitor Serial Output

After flashing, watch the device output:

```bash
make monitor PORT=/dev/ttyUSB0
```

Expected output from the LED blink example:

```
Hello from .NET nanoFramework!
Starting LED blink example...
LED ON
LED OFF
LED ON
LED OFF
...
```

To exit: `Ctrl+A Q` (in screen)

## Step 5: Customize for Your Board

The example project pins are defaults:

**Edit `src/Program.cs` and adjust `LED_PIN`:**

```csharp
// Current default
private const int LED_PIN = 2;
```

### Pin Numbers by Board

**ESP32:**

- GPIO 2 (common choice)
- GPIO 25, 26, 27 (if your board has onboard LED)
- Check your board's pinout diagram

**ESP8266:**

- GPIO 2 / D4 (blue LED on most boards)
- Check your module's pinout

**RP Pico:**

- GPIO 25 (built-in LED—no external LED needed!)
- Or any GPIO 0-28

**Arduino:**

- Pin 13 (built-in LED on most Uno/Nano boards)
- Or any digital pin

## All Available Commands

```bash
# Build
make build

# Clean build artifacts
make clean

# Detect devices
make detect

# Monitor serial
make monitor PORT=/dev/ttyUSB0

# Flash ESP32
make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0

# Flash ESP8266
make flash-esp PLATFORM=esp8266 PORT=/dev/ttyUSB0

# Flash RP Pico
make flash-pico

# Flash STM32 (if you get one later)
make flash-stm32 TARGET=ST_NUCLEO144_F746ZG
```

## USB Permission Issues (Linux)

If you get "Permission denied" on `/dev/ttyUSB*`:

```bash
sudo usermod -a -G dialout $USER
# Logout and login for changes to take effect
# Or restart shell: exec bash
```

## Drivers

| Board | Driver | Link |
|---|---|---|
| ESP32/ESP8266 | CH340 or CP2102 | [Silicon Labs CP210x](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers) |
| RP Pico | None (USB native) | N/A |
| Arduino | Optional (CH340) | [Arduino.cc](https://www.arduino.cc/en/guide/linux) |

## Next Steps

1. ✅ Flash firmware
2. ✅ Verify serial output with `make monitor`
3. 📝 Explore other examples: [nanoFramework Samples](https://github.com/nanoframework/Samples)
4. 🔌 Try I2C, SPI, ADC, PWM examples
5. 📡 Connect to WiFi (ESP32/ESP8266)
6. ☁️ Connect to Azure IoT

## Debugging

### Common Issues

**1. Device not detected**

```bash
make detect    # Run this first
lsusb          # Check USB
```

**2. Permission denied on /dev/ttyUSB0**

```bash
sudo usermod -a -G dialout $USER
```

**3. nanoff command not found**

```bash
nix develop              # Ensure you're in nix shell
which nanoff             # Verify it's available
dotnet tool list -g      # Check installed tools
```

**4. Build fails with "Framework not found"**

```bash
# The project file may need .NET nanoFramework SDK installed
# Inside nix develop, this is auto-handled, but check:
dotnet nuget locals all --clear
dotnet build             # Try again
```

## VS Code Integration (Optional)

For live debugging on your device:

1. Install VS Code extension: **nanoFramework** (by nanoframework.net)
2. Open this project folder in VS Code
3. From command palette: `nanoFramework: Flash device`
4. Select your board and port

This enables:

- Live code debugging
- Breakpoints on device
- Real-time variable inspection

## Useful Links

- **Device Support**: <https://github.com/nanoframework/Home#firmware-for-reference-boards>
- **Sample Projects**: <https://github.com/nanoframework/Samples>
- **Pin Diagrams**: <https://www.espressif.com/> (ESP32), <https://www.raspberrypi.com/products/raspberry-pi-pico/> (Pico)
- **Community Help**: <https://discord.gg/gCyBu8T>

---

**Happy hacking!** 🚀

If you get stuck, check the [nanoFramework Discord](https://discord.gg/gCyBu8T) or the [Troubleshooting Guide](https://docs.nanoframework.net/content/getting-started-guides/trouble-shooting-guide.html).
