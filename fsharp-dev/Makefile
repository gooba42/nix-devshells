# Makefile for F# template
.PHONY: build run clean

build:
	dotnet build src/HelloFSharp.fsproj

run:
	dotnet run --project src/HelloFSharp.fsproj

clean:
	dotnet clean src/HelloFSharp.fsproj


# Flatpak build target
.PHONY: flatpak-build
flatpak-build:
	flatpak-builder --force-clean build-flatpak flatpak/app.flatpak.json
