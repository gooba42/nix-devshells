
# Forth Dev Flake

- Dev shell: gforth
- Example: `src/hello.fs` (minimal hello world)

## GitHub Location

Find the latest version of this template at:
<https://github.com/gooba42/nixos-ng/tree/master/flakes/forth-dev>

---

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/forth-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/forth-dev
```

## Build and Run the Example

```sh
gforth src/hello.fs
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Forth packaging docs](https://nixos.org/manual/nixpkgs/stable/#forth) for more details.
