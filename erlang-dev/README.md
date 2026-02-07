
# Erlang Dev Flake

- Dev shell: Erlang
- Example: `src/main.erl` (minimal hello world)

## Usage

```sh
nix develop github:gooba42/nixos-ng?dir=flakes/erlang-dev
```

To use the template:

```sh
nix flake init -t github:gooba42/nixos-ng?dir=flakes/erlang-dev
```

## Build and Run the Example

```sh
erlc src/main.erl
erl -noshell -pa src -s main start -s init stop
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Erlang packaging docs](https://nixos.org/manual/nixpkgs/stable/#erlang) for more details.
