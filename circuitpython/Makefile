# Makefile for CircuitPython template
.PHONY: build clean flash check-circuitpy install-circuitpython download-guide detect-board help

# Variables
CIRCUITPY_MOUNT := /media/$(USER)/CIRCUITPY
BOOTSEL_MOUNT := /media/$(USER)/RPI-RP2
BOOT_MOUNT := /media/$(USER)/BOOT
FIRMWARE_DIR := firmware
FIRMWARE_UF2 := $(shell find $(FIRMWARE_DIR) -name "*.uf2" 2>/dev/null | head -1)
FIRMWARE_BIN := $(shell find $(FIRMWARE_DIR) -name "*.bin" 2>/dev/null | head -1)

help:
	@echo "CircuitPython Makefile Commands:"
	@echo "  make detect-board           - Detect connected board and show firmware link"
	@echo "  make check-circuitpy        - Check if CircuitPython is installed"
	@echo "  make flash                  - Copy Python files to CIRCUITPY device"
	@echo "  make install-circuitpython  - Install CircuitPython firmware from firmware/"
	@echo "  make download-guide         - Show firmware download instructions"
	@echo "  make clean                  - Remove Python cache files"

build:
	@echo "Nothing to build for CircuitPython. Copy .py files to your device."

# Check if CircuitPython is properly installed
check-circuitpy:
	@echo "Checking for CircuitPython installation..."
	@if [ -d "$(CIRCUITPY_MOUNT)" ]; then \
		echo "✓ CircuitPython detected at $(CIRCUITPY_MOUNT)"; \
		if [ -f "$(CIRCUITPY_MOUNT)/boot_out.txt" ]; then \
			echo "✓ Firmware info:"; \
			cat "$(CIRCUITPY_MOUNT)/boot_out.txt"; \
		fi; \
	elif [ -d "$(BOOTSEL_MOUNT)" ]; then \
		echo "⚠ Device is in BOOTSEL mode ($(BOOTSEL_MOUNT))"; \
		echo "  This typically means CircuitPython is not installed or device was reset."; \
		$(MAKE) install-circuitpy; \
	elif [ -d "$(BOOT_MOUNT)" ]; then \
		echo "⚠ Device detected at $(BOOT_MOUNT)"; \
		echo "  This may indicate Arduino firmware or non-CircuitPython firmware."; \
		echo "  download-guidehon, you need to flash CircuitPython firmware."; \
		$(MAKE) install-circuitpy; \
	else \
		echo "✗ No CircuitPython device detected"; \
		echo "  Expected mount points:"; \
		echo "    - $(CIRCUITPY_MOUNT) (CircuitPython running)"; \
		echo "    - $(BOOTSEL_MOUNT) (RP2040 bootloader)"; \
		echo "    - $(BOOT_MOUNT) (Some other firmware)"; \
		echo ""; \
		echo "  Please connect your device or enter bootloader mode:"; \
		echo "    - RP2040: Hold BOOTSEL button while plugging in USB"; \
		echo "    - SAMD: Double-tap the reset button"; \
		echo "    - ESP32: May require holding BOOT button"; \
	fi

# Automated firmware installation
install-circuitpython:
	@echo "=== Installing CircuitPython Firmware ==="
	@echo ""
	@# Check for firmware files
	@if [ -z "$(FIRMWARE_UF2)" ] && [ -z "$(FIRMWARE_BIN)" ]; then \
		echo "✗ No firmware found in $(FIRMWARE_DIR)/"; \
		echo ""; \
		$(MAKE) download-guide; \
		exit 1; \
	fi
	@# Check for bootloader mode
	@if [ -d "$(BOOTSEL_MOUNT)" ]; then \
		if [ -n "$(FIRMWARE_UF2)" ]; then \
			echo "✓ Found firmware: $(FIRMWARE_UF2)"; \
			echo "✓ Bootloader detected at $(BOOTSEL_MOUNT)"; \
			echo "  Installing..."; \
			cp "$(FIRMWARE_UF2)" "$(BOOTSEL_MOUNT)/"; \
			echo "✓ Firmware installed! Device will reboot automatically."; \
			echo "  Wait a few seconds, then run 'make check-circuitpy'"; \
		else \
			echo "✗ UF2 firmware needed for $(BOOTSEL_MOUNT) but found: $(FIRMWARE_BIN)"; \
			echo "  ESP32 boards require esptool instead:"; \
			echo "  esptool.py --port /dev/ttyUSB0 write_flash 0x0 $(FIRMWARE_BIN)"; \
		fi; \
	elif [ -d "$(CIRCUITPY_MOUNT)" ]; then \
		echo "⚠ CircuitPython already running at $(CIRCUITPY_MOUNT)"; \
		echo "  To reinstall, enter bootloader mode first:"; \
		echo "  - RP2040: Hold BOOTSEL while plugging in"; \
		echo "  - SAMD: Double-tap reset button"; \
	else \
		echo "✗ Device not in bootloader mode"; \
		echo ""; \
		echo "Put device in bootloader mode:"; \
		echo "  RP2040 (Pico/Pico W):"; \
		echo "    1. Unplug device"; \
		echo "    2. Hold BOOTSEL button"; \
		echo "    3. Plug in USB while holding"; \
		echo "    4. Release when $(BOOTSEL_MOUNT) appears"; \
		echo ""; \
		echo "  SAMD21/51 (Metro/Feather M0/M4):"; \
		echo "    1. Double-tap reset button quickly"; \
		echo "    2. Wait for drive to appear"; \
		echo ""; \
		echo "  ESP32-S2/S3:"; \
		echo "    Use: esptool.py --port /dev/ttyUSB0 write_flash 0x0 $(FIRMWARE_DIR)/*.bin"; \
		exit 1; \
	fi

# Detect connected board and provide direct download link
detect-board:
	@echo "=== Detecting Board ==="
	@echo ""
	@DETECTED=0; \
	if command -v lsusb >/dev/null 2>&1; then \
		if lsusb | grep -q "2e8a:0003"; then \
			echo "✓ Detected: Raspberry Pi Pico (RP2040)"; \
			echo "  Download: https://circuitpython.org/board/raspberry_pi_pico/"; \
			DETECTED=1; \
		elif lsusb | grep -q "2e8a:000a"; then \
			echo "✓ Detected: Raspberry Pi Pico W (RP2040 + WiFi)"; \
			echo "  Download: https://circuitpython.org/board/raspberry_pi_pico_w/"; \
			DETECTED=1; \
		elif lsusb | grep -q "2e8a:0005"; then \
			echo "✓ Detected: Raspberry Pi Pico (RP2040 in BOOTSEL mode)"; \
			echo "  Download: https://circuitpython.org/board/raspberry_pi_pico/"; \
			DETECTED=1; \
		elif lsusb | grep -q "239a:" | head -1; then \
			VID_PID=$$(lsusb | grep "239a:" | head -1 | sed 's/.*ID \([0-9a-f:]\+\).*/\1/'); \
			echo "✓ Detected: Adafruit board ($$VID_PID)"; \
			echo "  Search: https://circuitpython.org/downloads?vendor=Adafruit"; \
			echo "  Common Adafruit boards:"; \
			echo "    - Feather RP2040: https://circuitpython.org/board/adafruit_feather_rp2040/"; \
			echo "    - Feather M4: https://circuitpython.org/board/adafruit_feather_m4_express/"; \
			echo "    - ItsyBitsy M4: https://circuitpython.org/board/adafruit_itsybitsy_m4_express/"; \
			echo "    - Metro M4: https://circuitpython.org/board/adafruit_metro_m4_express/"; \
			DETECTED=1; \
		elif lsusb | grep -q "303a:"; then \
			echo "✓ Detected: ESP32-S2/S3 board"; \
			echo "  Search: https://circuitpython.org/downloads?features=Wi-Fi&features=ESP32-S2&features=ESP32-S3"; \
			echo "  Common ESP32 boards:"; \
			echo "    - ESP32-S2: https://circuitpython.org/board/espressif_esp32s2_devkitc_1_n4/"; \
			echo "    - ESP32-S3: https://circuitpython.org/board/espressif_esp32s3_devkitc_1_n8/"; \
			DETECTED=1; \
		fi; \
		if [ $$DETECTED -eq 0 ]; then \
			echo "⚠ Board not automatically identified"; \
			echo "  Connected USB devices:"; \
			lsusb | grep -E "2e8a|239a|303a|10c4|1a86|0403" || lsusb; \
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
	@echo "=== CircuitPython Firmware Download Guide ==="
	@echo ""
	@echo "1. Visit: https://circuitpython.org/downloads"
	@echo "2. Find your board (e.g., Raspberry Pi Pico, Adafruit Feather)"
	@echo "3. Download the latest .uf2 or .bin firmware"
	@echo "4. Save to: $(FIRMWARE_DIR)/"
	@echo "5. Run: make install-circuitpython"
	@echo ""
	@echo "Or run 'make detect-board' to auto-detect your board"
	@echo ""

flash: check-circuitpy
	@if [ -d "$(CIRCUITPY_MOUNT)" ]; then \
		echo "Copying files to CIRCUITPY..."; \
		cp src/*.py $(CIRCUITPY_MOUNT)/; \
		echo "✓ Files copied successfully"; \
	else \
		echo "✗ Cannot flash: CIRCUITPY drive not found"; \
		echo "  Run 'make check-circuitpy' for diagnosis"; \
		exit 1; \
	fi

clean:
	@echo "Cleaning up..."
	find src -name '*.pyc' -delete
	find src -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
