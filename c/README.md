# C/C++ Nix Flake Template

This template provides a reproducible C/C++ development environment using Nix flakes.

## Quickstart

```sh
nix flake init -t path:../flakes#c
nix develop
make
./build/main
```

## Features

- DevShell with clang, cmake, codespell, conan, cppcheck, doxygen, gtest, lcov, gdb (if not Darwin)
- Example Makefile and src/
- Helper app: `nix run .#dev-helper`

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Project Metadata

See project.toml for example metadata.

---

## Included Project Layout

```
Makefile
src/
main.c
```

## Flatpak Packaging

This template supports building Flatpak packages for your C application.

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
flatpak install --user build-flatpak/org.example.cdevshell.flatpak
flatpak run org.example.cdevshell
```

You can use this as a starting point for your own C project.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs C packaging docs](https://nixos.org/manual/nixpkgs/stable/#c) for more details.

## Customization

Edit `flake.nix` to add packages or adjust compiler versions.
