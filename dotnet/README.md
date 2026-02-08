# .NET Development Template

Nix flake template for .NET development with SDK, EF Core, and optional Rider support.

## Automatic Environment Setup

When entering the devShell, the following setup happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **FHS Environment**: Creates a Filesystem Hierarchy Standard environment for maximum .NET compatibility
✓ **Environment Variables**: Sets DOTNET_ROOT, disables telemetry, configures CLI
✓ **NuGet Cache**: Configured to use `$HOME/.dotnet`

No manual setup needed! Just start coding.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

## Using .NET Project Templates

The .NET SDK includes built-in project templates accessible via `dotnet new`:

### List Available Templates

```bash
dotnet new list
```

### Common Templates

| Template Name | Short Name | Description |
|--------------|------------|-------------|
| Console Application | `console` | A command-line application |
| Class Library | `classlib` | A class library targeting .NET |
| ASP.NET Core Web App | `webapp` | ASP.NET Core Web App with Razor Pages |
| ASP.NET Core Web API | `webapi` | ASP.NET Core Web API |
| ASP.NET Core MVC | `mvc` | ASP.NET Core Web App (Model-View-Controller) |
| Blazor WebAssembly | `blazorwasm` | Blazor WebAssembly App |
| Blazor Server | `blazorserver` | Blazor Server App |
| Worker Service | `worker` | A long-running background service |
| xUnit Test Project | `xunit` | xUnit test project |
| NUnit Test Project | `nunit` | NUnit test project |
| MSTest Test Project | `mstest` | MSTest test project |

### Create a New Project

```bash
# Console application
dotnet new console -n MyApp

# Web API
dotnet new webapi -n MyApi

# Class library
dotnet new classlib -n MyLibrary

# Test project
dotnet new xunit -n MyApp.Tests
```

For the complete list of templates, see the [official .NET templates documentation](https://github.com/dotnet/templating/wiki/Available-templates-for-dotnet-new).

### Installing Additional Template Packs

Use the included `install-templates.sh` helper script to quickly install popular template packs from NuGet:

```bash
# Install all popular templates
./install-templates.sh all

# Install by category
./install-templates.sh web       # Web development templates
./install-templates.sh cloud     # AWS Lambda, Azure Functions
./install-templates.sh testing   # NUnit, SpecFlow, etc.
./install-templates.sh mobile    # Avalonia, Xamarin

# Install specific templates
./install-templates.sh aws       # AWS Lambda
./install-templates.sh nunit     # NUnit 3
./install-templates.sh avalonia  # Avalonia UI (cross-platform)
./install-templates.sh clean     # Clean Architecture

# See all options
./install-templates.sh list
```

**Popular Template Packs:**

| Template Pack | Install Command | Description |
|--------------|-----------------|-------------|
| AWS Lambda | `dotnet new install Amazon.Lambda.Templates` | AWS Lambda function templates |
| .NET Boxed | `dotnet new install Boxed.Templates` | Production-ready ASP.NET Core templates |
| Avalonia UI | `dotnet new install Avalonia.Templates` | Cross-platform UI framework |
| NUnit 3 | `dotnet new install NUnit3.DotNetNew.Template` | NUnit test project templates |
| SpecFlow | `dotnet new install SpecFlow.Templates.DotNet` | BDD testing with SpecFlow |
| Clean Architecture | `dotnet new install Paulovich.Manga` | Clean Architecture pattern |
| Giraffe (F#) | `dotnet new install giraffe-template` | F# web framework |
| SAFE Stack (F#) | `dotnet new install SAFE.Template` | Full-stack F# development |

After installing, use `dotnet new list` to see all available templates.

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

| Tool | Purpose |
|------|---------|
| .NET SDK | Complete .NET development kit with compiler, runtime, and CLI |
| dotnet-ef | Entity Framework Core tools for database migrations and scaffolding |
| dotnet-aspnetcore | ASP.NET Core runtime for web applications |
| csharpier | Opinionated C# code formatter |
| NuGet | Package manager (included with SDK) |

### Tool Versions

The SDK includes access to all official `dotnet new` templates - see "Using .NET Project Templates" section above.

## Testing & Development Features

```bash
# Run tests
dotnet test

# Format code
dotnet csharpier .

# Watch mode (auto-rebuild on changes)
dotnet watch run

# Add a package
dotnet add package Newtonsoft.Json

# Restore dependencies
dotnet restore

# Create a solution file
dotnet new sln -n MySolution
dotnet sln add MyProject/MyProject.csproj
```

## Project Layout

Typical .NET project structure:

```
MyProject/
├── src/
│   ├── MyProject/
│   │   ├── MyProject.csproj
│   │   └── Program.cs
│   └── MyProject.Api/
│       ├── MyProject.Api.csproj
│       └── Controllers/
├── tests/
│   └── MyProject.Tests/
│       ├── MyProject.Tests.csproj
│       └── UnitTest1.cs
└── MyProject.sln
```

## Customization

Edit `flake.nix` to adjust .NET version or add packages. Update `deps.nix` after adding NuGet dependencies with `nix flake update`.
