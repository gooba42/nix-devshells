direnv allow

# C++ Development Template

Nix flake template for C++ development with modern build tools and a minimal example project.

## Features

- GCC/Clang compilers
- CMake
- Make
- GDB debugger
- Clang-format
- Example project: `src/main.cpp` (hello world)

## Quick Start

### Enter the Dev Shell

```bash
nix develop
# or with direnv:

```

### Build and Run the Example

```bash
mkdir build && cd build
cmake ..
make
./cpp-flake-app
```

## Included Project Layout

```
 CMakeLists.txt
 src/
  main.cpp
```

## Flatpak Packaging

This template supports building Flatpak packages for your C++ application.

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
flatpak install --user build-flatpak/org.example.cppdevshell.flatpak
flatpak run org.example.cppdevshell
```

You can use this as a starting point for your own C++ project.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs C++ packaging docs](https://nixos.org/manual/nixpkgs/stable/#cpp) for more details.

## Customization

Edit `flake.nix` to add packages or adjust C++ standards.
