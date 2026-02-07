# Makefile for Embedded Rust template
.PHONY: build flash clean

build:
	cargo build --release

flash:
	openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program target/release/firmware.elf verify reset exit"

clean:
	cargo clean
