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

You can use this as a starting point for your own C project.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs C packaging docs](https://nixos.org/manual/nixpkgs/stable/#c) for more details.

## Customization

Edit `flake.nix` to add packages or adjust compiler versions.
