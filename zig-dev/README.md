
# Zig Dev Flake

- Dev shell: Zig
- Example: `src/main.zig` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/zig-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/zig-dev
```

## Build and Run the Example

```sh
zig build-exe src/main.zig
./main
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Zig packaging docs](https://nixos.org/manual/nixpkgs/stable/#zig) for more details.
