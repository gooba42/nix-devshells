.PHONY: help build clean detect monitor flash-esp flash-pico flash-stm32

help:
	@echo "================================"
	@echo ".NET nanoFramework Project"
	@echo "================================"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "  make build              Build the C# project"
	@echo "  make clean              Remove build artifacts"
	@echo "  make detect             Detect connected microcontroller devices"
	@echo "  make monitor PORT=/dev/ttyUSB0  Open serial monitor"
	@echo ""
	@echo "  make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0"
	@echo "                          Flash ESP32/ESP8266 (platform: esp32 or esp8266)"
	@echo ""
	@echo "  make flash-pico         Flash RP Pico (DFU mode)"
	@echo ""
	@echo "  make flash-stm32 TARGET=ST_NUCLEO144_F746ZG"
	@echo "                          Flash STM32 board"
	@echo ""
	@echo "  make help               Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  nix develop             Enter dev environment"
	@echo "  make build              Build project"
	@echo "  make detect             Find connected boards"
	@echo "  make flash-esp PLATFORM=esp32 PORT=/dev/ttyUSB0"
	@echo "  make monitor PORT=/dev/ttyUSB0"

build:
	dotnet build

clean:
	dotnet clean
	rm -rf bin/ obj/

detect:
	@bash scripts/detect-devices.sh

PORT ?= /dev/ttyUSB0
BAUD ?= 115200

monitor:
	@bash scripts/monitor-serial.sh $(PORT) $(BAUD)

PLATFORM ?= esp32
flash-esp:
	@bash scripts/flash-esp.sh $(PLATFORM) $(PORT)

flash-pico:
	@bash scripts/flash-pico.sh --dfu

TARGET ?= ST_NUCLEO144_F746ZG
DFU ?=
flash-stm32:
	@bash scripts/flash-stm32.sh $(TARGET) $(DFU)
