# Makefile for KDE/Qt6 template
.PHONY: build run clean

build:
	cmake -B build
	cmake --build build

run:
	./build/your-app

clean:
	rm -rf build

# Flatpak build target
.PHONY: flatpak-build
flatpak-build:
	flatpak-builder --force-clean build-flatpak flatpak/app.flatpak.json
