# .NET Development Template

Nix flake template for .NET development with SDK, EF Core, and optional Rider support.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

The template uses an FHS environment for maximum .NET compatibility.

## Usage

```bash
# Build
dotnet build

# Run
dotnet run

# Launch Rider (if installed)
rider .
```

## Building

```bash
nix build
./result/bin/SampleApp
```

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs .NET packaging docs](https://nixos.org/manual/nixpkgs/stable/#dotnet) for more details.

## Included Tools

- .NET SDK
- EF Core
- ASP.NET Core runtime
- NuGet

## Customization

Edit `flake.nix` to adjust .NET version or add packages. Update `deps.nix` after adding NuGet dependencies with `nix flake update`.
