
# Clojure Dev Flake

- Dev shell: Clojure CLI + Leiningen
- Template: `src/main.clj` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/clojure-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/clojure-dev
```

## Build and Run the Example

```sh
clojure src/main.clj
```

## Packaging for nixpkgs

This template includes a dev shell with Clojure CLI and Leiningen, and is structured for easy packaging in nixpkgs. To package your project, add a default.nix or flake.nix with a derivation using `buildClojurePackage` or similar from nixpkgs.
