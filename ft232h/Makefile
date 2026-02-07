.PHONY: help venv install shell scan-i2c gpio detect clean

# Check if we're in nix develop; if not, Python won't be available
# The template is designed to run: nix develop && make <target>
PY ?= python3
VENV ?= .venv
BIN := $(VENV)/bin
PIP := $(BIN)/pip
PYBIN := $(BIN)/python

# Helper to check if python3 is available (indicates nix develop is active)
CHECK_PYTHON = @if ! command -v python3 >/dev/null 2>&1; then \
	echo "ERROR: python3 not found. You must run: nix develop"; \
	echo "Then run: make <target>"; \
	exit 1; \
fi

help:
	@echo "FT232H Blinka Development"
	@echo ""
	@echo "Quick start:"
	@echo "  nix develop                  # enter dev environment"
	@echo "  make venv install            # create venv and install deps"
	@echo "  make scan-i2c                # run I2C scan example"
	@echo "  make gpio                    # run GPIO blink example"
	@echo ""
	@echo "Targets:"
	@echo "  venv                         - create virtualenv"
	@echo "  install                      - install python deps into venv"
	@echo "  shell                        - enter venv shell"
	@echo "  scan-i2c                     - run I2C scan example"
	@echo "  gpio                         - run GPIO blink example"
	@echo "  detect                       - list FTDI devices (lsusb)"
	@echo "  clean                        - remove virtualenv"

venv:
	$(CHECK_PYTHON)
	$(PY) -m venv $(VENV)

install: venv
	$(CHECK_PYTHON)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

shell: venv
	$(CHECK_PYTHON)
	@echo "Entering virtualenv shell (BLINKA_FT232H=$$BLINKA_FT232H)"
	. $(BIN)/activate && bash

scan-i2c: venv
	$(CHECK_PYTHON)
	. $(BIN)/activate && $(PYBIN) src/scan_i2c.py

gpio: venv
	$(CHECK_PYTHON)
	. $(BIN)/activate && $(PYBIN) src/gpio_blink.py

detect:
	lsusb | grep -i ftdi || true
	@echo "If nothing shows, check cables/permissions."

clean:
	rm -rf $(VENV)
