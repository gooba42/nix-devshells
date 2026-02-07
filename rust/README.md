# Rust Nix Flake Template

This template provides a reproducible Rust development environment using Nix flakes and the fenix toolchain.

## Quickstart

```sh
nix flake init -t path:../flakes#rust
nix develop
cargo build
```

## Features

- DevShell with cargo, rustc, clippy, rustfmt, rust-analyzer, probe-rs, espflash, openocd, minicom, elf2uf2-rs, picotool, avrdude, ravedude
- Example Cargo.toml and src/
- Helper app: `nix run .#dev-helper`

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Project Metadata

See project.toml for example metadata.

---

## Included Tools

- Rust stable (rustc, cargo)
- clippy
- rustfmt
- rust-analyzer
- rust-src
- probe-rs, espflash, openocd, minicom, elf2uf2-rs, picotool, avrdude, ravedude

## Included Project Layout

```
Cargo.toml
src/
Makefile
```

You can use this as a starting point for your own Rust project.
