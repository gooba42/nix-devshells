#!/usr/bin/env bash
# detect-devices.sh - Helper script to detect connected microcontroller devices
# Shows available boards, serial ports, and DFU devices

set -euo pipefail

echo "=========================================="
echo "Microcontroller Device Detection"
echo "=========================================="
echo ""

echo "📡 Serial Ports (USB/UART devices):"
echo "---"
if [ -d /dev ]; then
    # Linux
    if ls /dev/ttyUSB* 2>/dev/null; then
        ls -lh /dev/ttyUSB*
    elif ls /dev/ttyACM* 2>/dev/null; then
        ls -lh /dev/ttyACM*
    else
        echo "  (None found)"
    fi
else
    # Windows/other
    ls COM* 2>/dev/null || echo "  (None found)"
fi
echo ""

echo "🔌 USB Devices (lsusb):"
echo "---"
if command -v lsusb &> /dev/null; then
    lsusb
else
    echo "  (lsusb not available)"
fi
echo ""

echo "DFU Devices (for RP Pico, STM32 in bootloader):"
echo "---"
if command -v dfu-util &> /dev/null; then
    dfu-util -l || echo "  (None in DFU mode)"
else
    echo "  (dfu-util not available)"
fi
echo ""

echo "Available nanoFramework Targets:"
echo "---"
if command -v nanoff &> /dev/null; then
    nanoff --listports
    echo ""
    echo "For all available boards, run:"
    echo "  nanoff --listboards"
else
    echo "  (nanoff not available)"
fi
echo ""

echo "Troubleshooting:"
echo "---"
echo "  • ESP32/ESP8266: Usually appears as /dev/ttyUSB0"
echo "  • Arduino: Usually appears as /dev/ttyACM0"
echo "  • RP Pico (DFU): Hold BOOTSEL while connecting USB"
echo "  • STM32 (ST-Link): Check JTAG connection"
echo ""
echo "Grant USB permissions (Linux):"
echo "  sudo usermod -a -G dialout \$USER"
echo "  (Logout and login again)"
