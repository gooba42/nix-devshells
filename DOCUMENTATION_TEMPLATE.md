# Template Documentation Standard

This guide provides a consistent documentation structure for all language templates in this flakes collection.

## Template Structure

Every template README.md should include these sections in order:

### 1. Title & Overview

```markdown
# [Language] Development Template

Brief description of what the template provides (1-2 sentences).
```

### 2. Quick Start

```markdown
## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

```

### 3. Automatic Environment Setup
```markdown
### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **[Other Setup]**: Description of what happens
✓ **[Tool Installation]**: What tools/packages are installed via pip/npm/etc
✓ **[Banner]**: Environment banner displays available tools

No manual setup needed! Just start coding.
```

Note: Examine the template's `flake.nix` shellHook to determine what to document here.

### 4. Available Tools / Included Tools

```markdown
## Included Tools

| Tool | Purpose |
|------|---------|
| `tool1` | What it does |
| `tool2` | What it does |
```

Or for simpler templates:

```markdown
## Available Tools

- **toolname** — Short description
- **toolname** — Short description
```

Extract from:

1. `flake.nix` `packages` list (native tools)
2. `flake.nix` shellHook pip/npm/etc install commands
3. Language-specific toolchain items

### 5. Testing & Development Features (if applicable)

```markdown
## Testing & Development Features

Available testing/development tools:

- **pytest** — Unit testing framework
- **black** — Code formatter
- **[others]** — Descriptions

**Example usage:**

```bash
# Run tests
[command to run tests]

# Format code
[command to format]
```

```

### 6. Project Structure
```markdown
## Project Structure

```

my-project/
├── src/
│   └── [main source files]
├── tests/
│   └── [test files]
├── flake.nix               # Nix environment definition
├── .envrc                  # direnv setup (auto-created)
└── [language-specific files (Cargo.toml, go.mod, etc.)]

```
```

### 7. Common Tasks / Makefile Targets (if applicable)

```markdown
## Makefile Targets

| Target | Purpose |
|--------|---------|
| `make build` | Build the project |
| `make test` | Run tests |
```

### 8. Resources / Links

```markdown
## Resources

- [Official Documentation](link)
- [Getting Started Guide](link)
- [Troubleshooting](link)
```

## Extraction Guide

For each template:

1. **Find the shellHook in flake.nix** - This contains automatic setup actions

   ```bash
   grep -A 20 "shellHook = ''" flake.nix
   ```

2. **List packages** - What tools are provided

   ```bash
   grep -E "pkgs\.|buildInputs|packages" flake.nix | head -20
   ```

3. **Check for special features** - Testing tools, formatters, language-specific items

   ```bash
   grep -i "pytest\|black\|cargo\|rustup\|go\|java" flake.nix
   ```

4. **Review existing README** - Preserve existing good content, add missing sections

## Consistency Checklist

- [ ] Title matches template directory name (Go, Java, Rust, Python, etc.)
- [ ] Quick Start section shows nix develop / direnv allow
- [ ] Automatic Environment Setup documents what shellHook does
- [ ] Included Tools table or list matches packages
- [ ] Testing section present if applicable
- [ ] Project Structure shows expected layout
- [ ] Common commands/tasks documented
- [ ] Links to official resources

## Examples

See the following fully-documented templates as references:

- `/home/gooba42/nixos/flakes/circuitpython/README.md` - Comprehensive
- `/home/gooba42/nixos/flakes/micropython/README.md` - Comprehensive
- `/home/gooba42/nixos/flakes/python/README.md` - Basic (needs enhancement)

## Template Sections Summary

Minimum sections (all templates should have):

1. Title & Overview
2. Quick Start
3. Automatic Environment Setup
4. Included Tools

Extended sections (add if applicable):
5. Testing & Development Features
6. Project Structure
7. Common Tasks / Make Targets
8. Resources
