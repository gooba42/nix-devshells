#!/usr/bin/env bash
# monitor-serial.sh - Helper script to open serial monitor
# Usage: ./monitor-serial.sh [port] [baudrate]

set -euo pipefail

PORT="${1:-}"
BAUD="${2:-115200}"

if [ -z "$PORT" ]; then
    echo "Usage: $0 <port> [baudrate]"
    echo ""
    echo "Detect ports:"
    echo "  nanoff --listports"
    echo "  ls -la /dev/tty*"
    echo ""
    echo "Common examples:"
    echo "  $0 /dev/ttyUSB0          # Linux USB"
    echo "  $0 /dev/ttyACM0          # Linux Arduino"
    echo "  $0 COM5                  # Windows"
    echo ""
    exit 1
fi

echo "========================================="
echo "Serial Monitor: $PORT @ ${BAUD} baud"
echo "========================================="
echo ""
echo "Press Ctrl+A then Q to exit (or Ctrl+C)"
echo ""

# Try to use screen (most common)
if command -v screen &> /dev/null; then
    echo "Using screen..."
    exec screen "$PORT" "$BAUD"
elif command -v minicom &> /dev/null; then
    echo "Using minicom..."
    exec minicom -D "$PORT" -b "$BAUD"
elif command -v picocom &> /dev/null; then
    echo "Using picocom..."
    exec picocom -b "$BAUD" "$PORT"
else
    echo "ERROR: No serial monitor found (screen, minicom, or picocom required)" >&2
    exit 1
fi
