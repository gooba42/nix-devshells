# Python Development Template

Nix flake template for Python development with venv, pip, and direnv support.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

The template automatically creates a `.venv` virtual environment on first activation.

## Usage

```bash
# Install packages
pip install requests

# Run your app
python src/app/__main__.py
```

## Building

```bash
nix build
./result/bin/app
```

## Included Tools

- Python 3.11 (configurable via `version` variable)
- pip
- venv with automatic shell hook

## Reusable Pattern

This template exports `mkPythonShell` for use in other flakes:

```nix
python-lib.mkPythonShell { 
  inherit pkgs; 
  pythonVersion = "3.12"; 
}
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Python packaging docs](https://nixos.org/manual/nixpkgs/stable/#python) for more details.

## Customization

Edit `flake.nix` to change Python version or add system packages.
