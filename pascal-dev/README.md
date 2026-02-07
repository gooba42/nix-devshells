
# Pascal Dev Flake

Find the latest version of this template at:
<https://github.com/gooba42/nixos-ng/tree/master/flakes/pascal-dev>

A Nix flake template for Pascal development. Provides a dev shell and a minimal Pascal project.

## Features

- Free Pascal compiler and dev shell
- Example project: `src/main.pas` (hello world)
- Ready for extension with additional Pascal modules

## Quick Start

### Enter the Dev Shell

```bash
nix develop github:gooba42/nixos-ng?dir=flakes/pascal-dev
```

### Initialize a New Project from Template

```bash
nix flake init -t github:gooba42/nixos-ng?dir=flakes/pascal-dev
```

### Build and Run the Example

```bash
fpc src/main.pas
./main
```

## Included Project Layout

```
 src/
  main.pas
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Pascal packaging docs](https://nixos.org/manual/nixpkgs/stable/#pascal) for more details.

You can use this as a starting point for your own Pascal project.
