
# Tcl/Tk Dev Flake

- Dev shell: Tcl/Tk
- Example: `src/main.tcl` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/tcltk-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/tcltk-dev
```

## Build and Run the Example

```sh
tclsh src/main.tcl
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Tcl packaging docs](https://nixos.org/manual/nixpkgs/stable/#tcl) for more details.
