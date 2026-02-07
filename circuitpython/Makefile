# Makefile for CircuitPython template
.PHONY: build clean flash

build:
	@echo "Nothing to build for CircuitPython. Copy .py files to your device."

flash:
	@echo "Copying files to CIRCUITPY..."
	cp src/*.py /media/$USER/CIRCUITPY/

clean:
	@echo "Cleaning up..."
	find src -name '*.pyc' -delete
