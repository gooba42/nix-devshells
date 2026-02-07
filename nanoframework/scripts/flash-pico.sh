#!/usr/bin/env bash
# flash-pico.sh - Helper script to flash RP Pico devices via DFU
# Usage: ./flash-pico.sh [--dfu]

set -euo pipefail

DFU_MODE="${1:---dfu}"

echo "========================================"
echo "Flashing RP Pico (DFU Mode)"
echo "========================================"
echo ""
echo "⚠️  Make sure your RP Pico is in DFU mode:"
echo "   1. Hold BOOTSEL button"
echo "   2. While holding, connect USB to computer"
echo "   3. Release BOOTSEL button"
echo ""
echo "Check device detection:"
dfu-util -l

echo ""
echo "Proceeding with nanoff..."
echo ""

nanoff --target RP2040_NANO --update $DFU_MODE

echo ""
echo "✓ Flashing complete!"
