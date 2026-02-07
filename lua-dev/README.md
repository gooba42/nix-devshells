
# Lua Dev Flake

Find the latest version of this template at:
<https://github.com/gooba42/nixos-ng/tree/master/flakes/lua-dev>

A Nix flake template for Lua development. Provides a dev shell and a minimal Lua project.

## Features

- Lua interpreter and dev shell
- Example project: `src/main.lua` (hello world)
- Ready for extension with additional Lua modules

## Quick Start

### Enter the Dev Shell

```bash
nix develop github:gooba42/nixos-ng?dir=flakes/lua-dev
```

### Initialize a New Project from Template

```bash
nix flake init -t github:gooba42/nixos-ng?dir=flakes/lua-dev
```

### Run the Example

```bash
lua src/main.lua
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Lua packaging docs](https://nixos.org/manual/nixpkgs/stable/#lua) for more details.

## Included Project Layout

```
 src/
  main.lua
```

You can use this as a starting point for your own Lua project.
