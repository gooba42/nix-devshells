# KDE/Qt6 Development Template

Find the latest version of this template at:
<https://github.com/gooba42/nixos-ng/tree/master/flakes/kdeqt6-dev>

A Nix flake template for KDE/Qt6 (Wayland) C++ development. Provides a full devshell for building, testing, and debugging KDE/Qt6 applications on modern Linux.

## Features

- **Qt6 full stack**: Includes all Qt6 modules, QtWayland, and KDE Frameworks 6
- **KDE Frameworks**: kf6, kio, kxmlgui, extra-cmake-modules
- **Wayland/Plasma**: wayland, plasma-wayland-protocols, dbus
- **C++ Toolchain**: GCC, CMake, Ninja, pkg-config, gdb, valgrind, clang-tools
- **Nix utilities**: alejandra, statix, deadnix, nix-init, nix-update, nix-output-monitor, nix-tree, nvd
- **Git**: Version control ready

## Quick Start

### Enter the Dev Shell

```bash
nix develop github:gooba42/nixos-ng?dir=flakes/kdeqt6-dev
```

Or, if using direnv:

```bash
direnv allow
```

### Initialize a New Project from Template

```bash
nix flake init -t github:gooba42/nixos-ng?dir=flakes/kdeqt6-dev
```

### Build Your Project

Typical CMake/Ninja workflow:

```bash
mkdir build && cd build
cmake .. -G Ninja
ninja
```

### Run Your App

```bash
./your-app-binary
```

## Customization

Edit `flake.nix` to add or remove packages, or to adjust Qt/KDE versions. For more advanced KDE/Qt6 project setup, see the KDE and Qt documentation.

## Included Project Layout

This template includes a minimal CMake-based Qt6/KDE project at the root:

```
  CMakeLists.txt
  src/
    main.cpp
```

You can use this as a starting point for your own app, or replace it with your own CMake project. Advanced users can add more Qt/KDE modules as needed.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs KDE/Qt packaging docs](https://nixos.org/manual/nixpkgs/stable/#qt) for more details.

---

For more, see: <https://community.kde.org/Get_Involved/development> and <https://doc.qt.io/qt-6/>

## Flatpak Packaging

This template supports building Flatpak packages for your KDE/Qt6 application.

### Build Flatpak Package

1. Ensure you have `flatpak-builder` installed.
2. Run:

  ```bash
  make flatpak-build
  ```

This will use the manifest at `flatpak/app.flatpak.json` to build a Flatpak bundle in the `build-flatpak/` directory.

### Customize Manifest

Edit `flatpak/app.flatpak.json` to update app ID, runtime, build commands, or sources as needed for your project.

### Install/Run Flatpak Locally

You can install and run the built Flatpak locally:

```bash
flatpak install --user build-flatpak/org.example.kdeqt6devshell.flatpak
flatpak run org.example.kdeqt6devshell
```
