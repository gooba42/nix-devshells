
# Racket Dev Flake

- Dev shell: Racket
- Template: `src/main.rkt` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/racket-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/racket-dev
```

## Build and Run the Example

```sh
racket src/main.rkt
```

## Packaging for nixpkgs

This template includes a dev shell with Racket, and is structured for easy packaging in nixpkgs. To package your project, add a default.nix or flake.nix with a derivation using `buildRacketPackage` or similar from nixpkgs.
