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

You can use this as a starting point for your own C++ project.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs C++ packaging docs](https://nixos.org/manual/nixpkgs/stable/#cpp) for more details.

## Customization

Edit `flake.nix` to add packages or adjust C++ standards.
