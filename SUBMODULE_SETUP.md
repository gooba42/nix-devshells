# Nix DevShells Repository

This repository provides reusable Nix flake templates for development environments across 40+ languages and frameworks.

## For NixOS Main Repo (as a git submodule)

### Initial Setup

When cloning the main nixos repo with this as a submodule:

```bash
git clone --recurse-submodules https://github.com/gooba42/nixos-ng.git
# Or if already cloned:
git submodule update --init --recursive
```

### What Happens Automatically

- Submodule is checked out at `./flakes/`
- Main flake.nix references `path:./flakes` — no changes needed
- All templates are available without modification to system configs

### Development Workflow

To update templates while developing:

```bash
cd flakes
# Make changes
git add .
git commit -m "feat: add new template or update existing"
git push origin main

# Back in nixos repo root
git add flakes
git commit -m "chore: update flakes submodule"
git push origin dev
```

### Releasing Versions

Tag releases in the flakes submodule for reproducibility:

```bash
cd flakes
git tag -a v1.0.0 -m "Release: initial devshells library"
git push origin v1.0.0
```

Then optionally pin the main flake to a specific tag:

```nix
# In nixos/flake.nix (optional - for pinned stability)
flakes-local.url = "github:gooba42/nix-devshells/v1.0.0";
```

## Standalone Usage

Other projects can use templates from this repo directly:

```bash
nix flake init -t github:gooba42/nix-devshells#rust
nix flake init -t github:gooba42/nix-devshells#python
```

Or from a specific version:

```bash
nix flake init -t github:gooba42/nix-devshells/v1.0.0#golang
```

## Contributing

See [TEMPLATE_STANDARDS.md](./TEMPLATE_STANDARDS.md) for template structure guidelines and [Adding Templates](#adding-templates) below.

### Adding Templates

1. Create a new directory: `mkdir my-language-dev`
2. Follow the [template structure](#template-structure)
3. Add entry to `flake.nix` templates output
4. Test locally: `nix flake init -t path:. --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable#my-language-dev`
5. Submit PR

### Template Structure

Each template (e.g., `python/`) should include:

```
python/
├── flake.nix           # Dev shell definition
├── README.md           # Usage instructions
├── .envrc              # direnv support
├── .gitignore
└── [example files]     # Sample project structure
```

## License & Maintenance

Maintained as part of the nixos-ng ecosystem. Same standards apply.
