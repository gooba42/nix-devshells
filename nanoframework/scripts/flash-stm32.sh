#!/usr/bin/env bash
# flash-stm32.sh - Helper script to flash STM32 devices
# Usage: ./flash-stm32.sh <target> [port]

set -euo pipefail

TARGET="${1:-}"
PORT="${2:-}"

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target> [port]"
    echo ""
    echo "Common STM32 targets:"
    echo "  ST_NUCLEO144_F746ZG       - Nucleo F746ZG (ST-Link)"
    echo "  ST_NUCLEO144_F429ZI       - Nucleo F429ZI (ST-Link)"
    echo "  ST_NUCLEO64_F411RE        - Nucleo F411RE (ST-Link)"
    echo ""
    echo "Examples (via ST-Link):"
    echo "  $0 ST_NUCLEO144_F746ZG"
    echo ""
    echo "Examples (via DFU):"
    echo "  $0 ST_NUCLEO144_F746ZG --dfu"
    echo ""
    echo "For DFU mode:"
    echo "  1. Put board in DFU mode (see board docs, usually bootloader jumper)"
    echo "  2. Run: dfu-util -l  (to verify device detection)"
    echo "  3. Run this script with --dfu flag"
    echo ""
    echo "List all available boards:"
    echo "  nanoff --listboards"
    exit 1
fi

DFU_FLAG=""
if [ "$PORT" == "--dfu" ]; then
    DFU_FLAG="--dfu"
    PORT=""
fi

echo "========================================"
echo "Flashing STM32: $TARGET"
echo "========================================"
echo ""

if [ -n "$DFU_FLAG" ]; then
    echo "⚠️  DFU mode - device should be detected:"
    dfu-util -l
    echo ""
    nanoff --target "$TARGET" --update $DFU_FLAG
else
    if [ -z "$PORT" ]; then
        echo "Using ST-Link (JTAG) connection..."
    fi
    nanoff --target "$TARGET" --update
fi

echo ""
echo "✓ Flashing complete!"
