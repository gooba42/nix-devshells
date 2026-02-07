
# FreeBASIC Dev Flake

- Dev shell: FreeBASIC
- Template: `src/main.bas` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/freebasic-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/freebasic-dev
```

## Build and Run the Example

```sh
fbc src/main.bas
./main
```

## Packaging for nixpkgs

This template includes a dev shell with FreeBASIC, and is structured for easy packaging in nixpkgs. To package your project, add a default.nix or flake.nix with a derivation using `buildBasicPackage` or similar from nixpkgs.
