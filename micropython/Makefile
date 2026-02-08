# Makefile for MicroPython template
.PHONY: build clean flash check-micropython install-micropython download-guide detect-board help repl

# Variables
BOOTSEL_MOUNT := /media/$(USER)/RPI-RP2
FIRMWARE_DIR := firmware
FIRMWARE_UF2 := $(shell find $(FIRMWARE_DIR) -name "*.uf2" 2>/dev/null | head -1)
FIRMWARE_BIN := $(shell find $(FIRMWARE_DIR) -name "*.bin" 2>/dev/null | head -1)
FIRMWARE_HEX := $(shell find $(FIRMWARE_DIR) -name "*.hex" 2>/dev/null | head -1)
FIRMWARE_DFU := $(shell find $(FIRMWARE_DIR) -name "*.dfu" 2>/dev/null | head -1)
SERIAL_PORT ?= /dev/ttyUSB0
BAUD_RATE := 115200

help:
	@echo "MicroPython Makefile Commands:"
	@echo "  make detect-board           - Detect connected board and show firmware link"
	@echo "  make check-micropython      - Check if MicroPython is installed"
	@echo "  make flash                  - Copy Python files to MicroPython device"
	@echo "  make install-micropython    - Install MicroPython firmware from firmware/"
	@echo "  make download-guide         - Show firmware download instructions"
	@echo "  make repl                   - Connect to MicroPython REPL"
	@echo "  make clean                  - Remove Python cache files"
	@echo ""
	@echo "Environment Variables:"
	@echo "  SERIAL_PORT=<port>         - Set serial port (default: /dev/ttyUSB0)"

build:
	@echo "Nothing to build for MicroPython. Copy .py files to your device."

# Check if MicroPython is properly installed
check-micropython:
	@echo "Checking for MicroPython installation..."
	@# Try to detect via REPL
	@if [ -e "$(SERIAL_PORT)" ]; then \
		echo "✓ Serial device detected: $(SERIAL_PORT)"; \
		echo "  Testing MicroPython..."; \
		if timeout 2 python3 -c "import serial; s=serial.Serial('$(SERIAL_PORT)', $(BAUD_RATE), timeout=1); s.write(b'\\x03\\x03'); import time; time.sleep(0.1); s.write(b'import sys\\r\\nprint(sys.implementation)\\r\\n'); print(s.read(200).decode('utf-8', errors='ignore'))" 2>/dev/null | grep -q "micropython\|MicroPython"; then \
			echo "✓ MicroPython is running!"; \
		else \
			echo "⚠ Device detected but MicroPython response unclear"; \
			echo "  Try: make repl"; \
		fi; \
	elif [ -d "$(BOOTSEL_MOUNT)" ]; then \
		echo "⚠ Device is in BOOTSEL mode ($(BOOTSEL_MOUNT))"; \
		echo "  This typically means MicroPython is not installed."; \
		echo "  Run: make install-micropython"; \
	else \
		echo "✗ No MicroPython device detected"; \
		echo "  Expected:"; \
		echo "    - Serial port: $(SERIAL_PORT) (or set SERIAL_PORT=/dev/ttyACM0)"; \
		echo "    - Bootloader: $(BOOTSEL_MOUNT)"; \
		echo ""; \
		echo "  Available serial devices:"; \
		@ls /dev/tty{USB,ACM}* 2>/dev/null || echo "    (none found)"; \
	fi

# Automated firmware installation
install-micropython:
	@echo "=== Installing MicroPython Firmware ==="
	@echo ""
	@# Check for firmware files
	@if [ -z "$(FIRMWARE_UF2)" ] && [ -z "$(FIRMWARE_BIN)" ] && [ -z "$(FIRMWARE_HEX)" ] && [ -z "$(FIRMWARE_DFU)" ]; then \
		echo "✗ No firmware found in $(FIRMWARE_DIR)/"; \
		echo ""; \
		$(MAKE) download-guide; \
		exit 1; \
	fi
	@# RP2040 UF2 installation
	@if [ -d "$(BOOTSEL_MOUNT)" ] && [ -n "$(FIRMWARE_UF2)" ]; then \
		echo "✓ Found firmware: $(FIRMWARE_UF2)"; \
		echo "✓ Bootloader detected at $(BOOTSEL_MOUNT)"; \
		echo "  Installing..."; \
		cp "$(FIRMWARE_UF2)" "$(BOOTSEL_MOUNT)/"; \
		echo "✓ Firmware installed! Device will reboot automatically."; \
		echo "  Wait a few seconds, then run 'make check-micropython'"; \
		exit 0; \
	fi
	@# ESP32/ESP8266 esptool installation
	@if [ -n "$(FIRMWARE_BIN)" ]; then \
		if [ -e "$(SERIAL_PORT)" ]; then \
			echo "✓ Found firmware: $(FIRMWARE_BIN)"; \
			echo "✓ Serial port detected: $(SERIAL_PORT)"; \
			echo "  Installing via esptool..."; \
			if command -v esptool.py >/dev/null 2>&1; then \
				esptool.py --port $(SERIAL_PORT) erase_flash; \
				esptool.py --port $(SERIAL_PORT) write_flash -z 0x0 "$(FIRMWARE_BIN)"; \
				echo "✓ Firmware installed!"; \
				echo "  Run 'make check-micropython' to verify."; \
			else \
				echo "✗ esptool.py not found. Install with: pip install esptool"; \
				exit 1; \
			fi; \
		else \
			echo "✗ Serial port $(SERIAL_PORT) not found"; \
			echo "  Available ports:"; \
			ls /dev/tty{USB,ACM}* 2>/dev/null || echo "  (none)"; \
			echo "  Set with: make install-micropython SERIAL_PORT=/dev/ttyACM0"; \
			exit 1; \
		fi; \
		exit 0; \
	fi
	@# STM32 DFU installation
	@if [ -n "$(FIRMWARE_DFU)" ]; then \
		echo "✓ Found firmware: $(FIRMWARE_DFU)"; \
		echo "  Installing via dfu-util..."; \
		if command -v dfu-util >/dev/null 2>&1; then \
			dfu-util -a 0 -d 0483:df11 -D "$(FIRMWARE_DFU)"; \
			echo "✓ Firmware installed!"; \
		else \
			echo "✗ dfu-util not found"; \
			exit 1; \
		fi; \
		exit 0; \
	fi
	@# Generic guidance
	@echo "⚠ Firmware found but device not in expected state"
	@echo ""
	@echo "For RP2040 boards:"
	@echo "  1. Hold BOOTSEL button"
	@echo "  2. Plug in USB"
	@echo "  3. Release BOOTSEL"
	@echo "  4. Run: make install-micropython"
	@echo ""
	@echo "For ESP32/ESP8266:"
	@echo "  1. Connect via USB"
	@echo "  2. Identify port: ls /dev/ttyUSB*"
	@echo "  3. Run: make install-micropython SERIAL_PORT=/dev/ttyUSB0"
	@echo ""
	@echo "For STM32:"
	@echo "  1. Put device in DFU mode (hold BOOT, press RESET)"
	@echo "  2. Run: make install-micropython"

# Detect connected board and provide direct download link
detect-board:
	@echo "=== Detecting Board ==="
	@echo ""
	@DETECTED=0; \
	if command -v lsusb >/dev/null 2>&1; then \
		if lsusb | grep -q "2e8a:0003\|2e8a:0005"; then \
			echo "✓ Detected: Raspberry Pi Pico (RP2040)"; \
			echo "  Download: https://micropython.org/download/RPI_PICO/"; \
			echo "  Latest: https://micropython.org/resources/firmware/RPI_PICO-latest.uf2"; \
			DETECTED=1; \
		elif lsusb | grep -q "2e8a:000a"; then \
			echo "✓ Detected: Raspberry Pi Pico W (RP2040 + WiFi)"; \
			echo "  Download: https://micropython.org/download/RPI_PICO_W/"; \
			echo "  Latest: https://micropython.org/resources/firmware/RPI_PICO_W-latest.uf2"; \
			DETECTED=1; \
		elif lsusb | grep -q "10c4:ea60"; then \
			echo "✓ Detected: ESP32 (CP2102 USB-Serial)"; \
			echo "  Download: https://micropython.org/download/ESP32_GENERIC/"; \
			echo "  Latest: https://micropython.org/resources/firmware/ESP32_GENERIC-latest.bin"; \
			echo "  Install: make install-micropython SERIAL_PORT=/dev/ttyUSB0"; \
			DETECTED=1; \
		elif lsusb | grep -q "1a86:7523"; then \
			echo "✓ Detected: ESP32/ESP8266 (CH340 USB-Serial)"; \
			echo "  ESP32 Download: https://micropython.org/download/ESP32_GENERIC/"; \
			echo "  ESP8266 Download: https://micropython.org/download/ESP8266_GENERIC/"; \
			echo "  Install: make install-micropython SERIAL_PORT=/dev/ttyUSB0"; \
			DETECTED=1; \
		elif lsusb | grep -q "303a:"; then \
			echo "✓ Detected: ESP32-S2/S3/C3"; \
			echo "  ESP32-S2: https://micropython.org/download/ESP32_GENERIC_S2/"; \
			echo "  ESP32-S3: https://micropython.org/download/ESP32_GENERIC_S3/"; \
			echo "  ESP32-C3: https://micropython.org/download/ESP32_GENERIC_C3/"; \
			echo "  Install: make install-micropython SERIAL_PORT=/dev/ttyUSB0"; \
			DETECTED=1; \
		elif lsusb | grep -q "0483:df11"; then \
			echo "✓ Detected: STM32 in DFU mode (PyBoard or similar)"; \
			echo "  PyBoard: https://micropython.org/download/PYBV11/"; \
			echo "  STM32F4: https://micropython.org/download/?mcu=STM32F4"; \
			DETECTED=1; \
		elif lsusb | grep -q "239a:"; then \
			echo "✓ Detected: Adafruit board"; \
			echo "  Check if your Adafruit board supports MicroPython"; \
			echo "  Many Adafruit boards use CircuitPython instead"; \
			echo "  MicroPython boards: https://micropython.org/download/?vendor=Adafruit"; \
			DETECTED=1; \
		fi; \
		if [ $$DETECTED -eq 0 ]; then \
			echo "⚠ Board not automatically identified"; \
			echo "  Connected USB devices:"; \
			lsusb | grep -E "2e8a|10c4|1a86|303a|0483|239a|0403" || lsusb; \
			echo ""; \
			$(MAKE) download-guide; \
		fi; \
	else \
		echo "⚠ lsusb not found, cannot detect board"; \
		$(MAKE) download-guide; \
	fi

# Guide for downloading firmware
download-guide:
	@echo ""
	@echo "=== MicroPython Firmware Download Guide ==="
	@echo ""
	@echo "1. Visit: https://micropython.org/download"
	@echo "2. Select your board:"
	@echo "   - RP2040 (Pico):         Download .uf2"
	@echo "   - ESP32/ESP8266:         Download .bin"
	@echo "   - STM32:                 Download .dfu or .hex"
	@echo "3. Save firmware to: $(FIRMWARE_DIR)/"
	@echo "4. Run: make install-micropython"
	@echo ""
	@echo "Or run 'make detect-board' to auto-detect your board"
	@echo ""

# Flash Python code to device
flash:
	@if [ -e "$(SERIAL_PORT)" ]; then \
		if command -v mpremote >/dev/null 2>&1; then \
			echo "Copying files to MicroPython device (mpremote)..."; \
			for file in src/*.py; do \
				mpremote connect $(SERIAL_PORT) cp $$file :$$(basename $$file); \
				echo "  Copied: $$file"; \
			done; \
			echo "✓ Files copied successfully"; \
		elif command -v ampy >/dev/null 2>&1; then \
			echo "Copying files to MicroPython device (ampy)..."; \
			for file in src/*.py; do \
				ampy --port $(SERIAL_PORT) put $$file; \
				echo "  Copied: $$file"; \
			done; \
			echo "✓ Files copied successfully"; \
		else \
			echo "✗ Neither mpremote nor ampy found"; \
			echo "  Install with: pip install mpremote"; \
			echo "  or: pip install adafruit-ampy"; \
			exit 1; \
		fi; \
	else \
		echo "✗ Cannot flash: Serial port $(SERIAL_PORT) not found"; \
		echo "  Set port: make flash SERIAL_PORT=/dev/ttyACM0"; \
		exit 1; \
	fi

# Connect to REPL
repl:
	@if [ -e "$(SERIAL_PORT)" ]; then \
		if command -v mpremote >/dev/null 2>&1; then \
			echo "Connecting to REPL (mpremote)..."; \
			echo "Press Ctrl-] to exit"; \
			mpremote connect $(SERIAL_PORT) repl; \
		elif command -v screen >/dev/null 2>&1; then \
			echo "Connecting to REPL (screen)..."; \
			echo "Press Ctrl-A then Ctrl-\\ to exit"; \
			screen $(SERIAL_PORT) $(BAUD_RATE); \
		elif command -v picocom >/dev/null 2>&1; then \
			echo "Connecting to REPL (picocom)..."; \
			echo "Press Ctrl-A then Ctrl-X to exit"; \
			picocom -b $(BAUD_RATE) $(SERIAL_PORT); \
		else \
			echo "✗ No terminal program found (mpremote/screen/picocom)"; \
			exit 1; \
		fi; \
	else \
		echo "✗ Serial port $(SERIAL_PORT) not found"; \
		echo "  Set port: make repl SERIAL_PORT=/dev/ttyACM0"; \
		exit 1; \
	fi

clean:
	@echo "Cleaning up..."
	find src -name '*.pyc' -delete
	find src -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
