
# Scala Dev Flake

- Dev shell: Scala CLI
- Example: `src/Main.scala` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/scala-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/scala-dev
```

## Build and Run the Example

```sh
scala-cli run src/Main.scala
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Scala packaging docs](https://nixos.org/manual/nixpkgs/stable/#scala) for more details.
