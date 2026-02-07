
# ANSI Common Lisp Dev Flake

- Dev shell: SBCL + Quicklisp
- Template: `src/main.lisp` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/cl-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/cl-dev
```

## Build and Run the Example

```sh
sbcl --script src/main.lisp
```

## Packaging for nixpkgs

This template includes a dev shell with SBCL and Quicklisp, and is structured for easy packaging in nixpkgs. To package your project, add a default.nix or flake.nix with a derivation using `buildLispPackage` or similar from nixpkgs.
