build:
	cargo build

run:
	cargo run

test:
	cargo test

clean:
	cargo clean

.PHONY: build run test clean


# Flatpak build target
.PHONY: flatpak-build
flatpak-build:
	flatpak-builder --force-clean build-flatpak flatpak/app.flatpak.json
