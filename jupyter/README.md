direnv allow

# Jupyter Development Template

Nix flake template for Jupyter notebook development with Python and ipykernel.

## Quick Start

```bash
nix develop
# or with direnv:

```

## Usage

```bash
# Start JupyterLab
jupyter lab

# Or classic notebook interface
jupyter notebook
```

## Build and Run the Example

# (No default src/ provided; create your own notebooks in the dev shell)

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/` (if you add code)
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Jupyter packaging docs](https://nixos.org/manual/nixpkgs/stable/#jupyter) for more details.

## Included Tools

- Python 3
- JupyterLab
- ipykernel
- poetry (package manager)

## Adding Packages

```bash
poetry add numpy pandas matplotlib
```

## Customization

Edit `flake.nix` to add Python packages or Jupyter extensions.
