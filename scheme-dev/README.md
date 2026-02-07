
# Scheme Dev Flake

- Dev shell: Guile Scheme
- Example: `src/main.scm` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/scheme-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/scheme-dev
```

## Build and Run the Example

```sh
guile src/main.scm
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Scheme packaging docs](https://nixos.org/manual/nixpkgs/stable/#scheme) for more details.
