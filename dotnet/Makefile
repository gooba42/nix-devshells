# Makefile for .NET template
.PHONY: build run clean

build:
	dotnet build

run:
	dotnet run

clean:
	dotnet clean


# Flatpak build target
.PHONY: flatpak-build
flatpak-build:
	flatpak-builder --force-clean build-flatpak flatpak/app.flatpak.json
