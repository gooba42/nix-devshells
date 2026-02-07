
# COBOL Dev Flake

- Dev shell: GnuCOBOL
- Template: `src/hello.cob` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/cobol-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/cobol-dev
```

## Build and Run the Example

```sh
cobc -x src/hello.cob
./hello
```

## Packaging for nixpkgs

This template includes a dev shell with GnuCOBOL, and is structured for easy packaging in nixpkgs. To package your project, add a default.nix or flake.nix with a derivation using `buildCobolPackage` or similar from nixpkgs.
