
# Prolog Dev Flake

Find the latest version of this template at:
<https://github.com/gooba42/nixos-ng/tree/master/flakes/prolog-dev>

A Nix flake template for Prolog development. Provides a dev shell and a minimal Prolog project.

## Features

- SWI-Prolog interpreter and dev shell
- Example project: `src/main.pl` (hello world)
- Ready for extension with additional Prolog modules

## Quick Start

### Enter the Dev Shell

```bash
nix develop github:gooba42/nixos-ng?dir=flakes/prolog-dev
```

### Initialize a New Project from Template

```bash
nix flake init -t github:gooba42/nixos-ng?dir=flakes/prolog-dev
```

### Run the Example

```bash
swipl src/main.pl
```

## Included Project Layout

```
 src/
  main.pl
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Prolog packaging docs](https://nixos.org/manual/nixpkgs/stable/#prolog) for more details.

You can use this as a starting point for your own Prolog project.
