# Go Nix Flake Template

This template provides a reproducible Go development environment using Nix flakes.

## Quickstart

```sh
nix flake init -t path:../flakes#golang
nix develop
make build
```

## Features

- DevShell with go, gotools, golangci-lint
- Example src/
- Helper Makefile for build/test/lint/clean

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Project Metadata

See project.toml for example metadata.

---

## Included Tools

- Go 1.24
- gopls (language server)
- golangci-lint
- gotools (goimports, godoc, etc.)

## Included Project Layout

```
src/
Makefile
```

You can use this as a starting point for your own Go project.
