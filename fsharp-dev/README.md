
# F# Dev Flake

- Dev shell: dotnet SDK (F#)
- Template: `src/Main.fs` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/fsharp-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/fsharp-dev
```

## Build and Run the Example

```sh
dotnet fsi src/Main.fs
```

## Packaging for nixpkgs

This template includes a dev shell with dotnet SDK, and is structured for easy packaging in nixpkgs. To package your project, add a default.nix or flake.nix with a derivation using `buildDotnetPackage` or similar from nixpkgs.
