
# Haskell Dev Flake

- Dev shell: GHC + Cabal
- Example: `src/Main.hs` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/haskell-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/haskell-dev
```

## Build and Run the Example

```sh
cabal run
# or, if you want to build manually:
cabal build
cabal exec haskell-flake-app
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Haskell packaging docs](https://nixos.org/manual/nixpkgs/stable/#haskell) for more details.
