# Python Development Template

Nix flake template for Python development with venv, pip, and direnv support.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Python Virtual Environment**: Creates and activates `.venv` virtual environment on first activation
✓ **Git Repository**: Initializes `.git` if not present
✓ **Environment Ready**: pip is configured and ready for package installation

No manual setup needed! Just start coding.

## Usage

```bash
# The .venv is automatically activated when you enter the shell
# Install packages (they go into .venv)
pip install requests pandas numpy

# Run your app
python src/app/__main__.py

# Run tests
pytest tests/

# Format code
black src/

# Check code quality
pylint src/
```

## Included Tools

| Tool | Purpose |
|------|---------|
| **python3** (3.11) | Python interpreter (configurable via `version` variable) |
| **pip** | Package installer |
| **venv** | Virtual environment management |
| **setuptools** | Package distribution utilities |
| **black** | Python code formatter |

## Testing & Development Features

The environment includes tools for testing and development:

- **pytest** - Unit testing framework (install with `pip install pytest`)
- **black** - Code formatting for consistent style
- **pylint** - Code analysis and linting
- **mypy** - Static type checker (install with `pip install mypy`)

**Example usage:**

```bash
# Run tests
pip install pytest
pytest tests/

# Format code
black src/

# Type check code
pip install mypy
mypy src/

# Install development dependencies
pip install -r requirements-dev.txt
```

## Project Layout

```
src/
  └── app/
      ├── __main__.py
      └── [package files]
tests/
  ├── test_main.py
  └── [test files]
pyproject.toml (or setup.py)
requirements.txt
requirements-dev.txt
.envrc
flake.nix
.gitignore
```

## Virtual Environment

The `.venv` directory is automatically created and activated. To understand what's happening:

```bash
# The venv is automatically activated
which python  # Shows path to .venv/bin/python

# Deactivate if needed (not usually necessary)
deactivate

# Re-activate manually (not usually necessary)
source .venv/bin/activate
```

**Note:** The `.venv` directory should be added to `.gitignore` (already included in template).

## Reusable Pattern

This template exports `mkPythonShell` for use in other flakes:

```nix
python-lib.mkPythonShell { 
  inherit pkgs; 
  pythonVersion = "3.12"; 
}
```

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Python packaging docs](https://nixos.org/manual/nixpkgs/stable/#python) for more details.

## Customization

Edit `flake.nix` to:

- Change Python version (3.11, 3.12, 3.13, etc.)
- Add system packages (e.g., libpq for psycopg2)
- Include additional development tools
