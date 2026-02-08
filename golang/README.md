# Go Nix Flake Template

This template provides a reproducible Go development environment using Nix flakes.

## Quick Start

```sh
nix develop
# or with direnv:
direnv allow
```

### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **Welcome Banner**: Displays available tools and quick commands
✓ **Environment Ready**: All Go tools configured and ready to use

No manual setup needed! Just start coding.

## Quickstart

```sh
nix flake init -t path:../flakes#golang
nix develop
make build
```

## Included Tools

| Tool | Purpose |
|------|---------|
| **go** (1.24) | Go compiler and runtime |
| **gopls** | Language server for IDE integration |
| **golangci-lint** | Go linter aggregator (catches common issues) |
| **gotools** | Go tooling suite including goimports, godoc |
| **gofumpt** | Stricter code formatter (stricter than gofmt) |

## Testing & Development Features

Build and testing tools:

- **go test** - Run unit and integration tests
- **go fmt** - Format code consistently
- **golangci-lint** - Comprehensive linting
- **go vet** - Examine code for suspicious constructs

**Example usage:**

```bash
# Run tests
go test ./...

# Check code with linting
golangci-lint run

# Format code
go fmt ./...

# Build the project
go build -o bin/app ./cmd/main.go
```

## Project Layout

```
src/
  ├── main.go (or cmd/main.go)
  └── [package files]
go.mod
go.sum
Makefile
.envrc
flake.nix
```

## Make Targets

Common Makefile targets:

```bash
make build          # Build the project
make test           # Run tests
make lint           # Run golangci-lint
make clean          # Clean build artifacts
make fmt            # Format code
```

## Legacy Usage

If you do not use flakes, run:

```sh
nix-shell
```

## Project Metadata

See project.toml for example metadata.

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Go packaging docs](https://nixos.org/manual/nixpkgs/stable/#go) for more details.

## Customization

Edit `flake.nix` to add or remove Go tools (e.g., additional linters, code generation tools).
