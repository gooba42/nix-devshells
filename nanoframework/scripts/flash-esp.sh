#!/usr/bin/env bash
# flash-esp.sh - Helper script to flash ESP32/ESP8266 devices
# Usage: ./flash-esp.sh [platform] [port]

set -euo pipefail

PLATFORM="${1:-esp32}"
PORT="${2:-}"

if [ -z "$PORT" ]; then
    echo "Usage: $0 <platform> <port>"
    echo ""
    echo "Platforms:"
    echo "  esp32    - ESP32 devices"
    echo "  esp8266  - ESP8266 devices"
    echo ""
    echo "Example:"
    echo "  $0 esp32 /dev/ttyUSB0"
    echo "  $0 esp8266 COM5"
    echo ""
    echo "Available ports:"
    nanoff --listports || echo "(Could not detect ports)"
    exit 1
fi

echo "========================================"
echo "Flashing $PLATFORM on $PORT"
echo "========================================"
echo ""

nanoff --platform "$PLATFORM" --serialport "$PORT" --update

echo ""
echo "✓ Flashing complete!"
echo ""
echo "Monitor output:"
echo "  screen $PORT 115200"
