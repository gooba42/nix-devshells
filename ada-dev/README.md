# Ada Nix Flake Template

This template provides a reproducible Ada development environment using Nix flakes and GNAT.

## Quickstart

```sh
nix flake init -t path:../flakes#ada-dev
nix develop
make build
make run
```

## Features

- DevShell with gnat, gprbuild, alejandra, statix, deadnix, git
- Example src/hello.adb
- Helper Makefile for build/run/clean

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
src/
Makefile
```

You can use this as a starting point for your own Ada project.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [Nixpkgs Ada packaging docs](https://nixos.org/manual/nixpkgs/stable/#ada) for more details.
