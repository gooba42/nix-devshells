# Integration with Nix Flakes Project

## Location

```
/home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework/
```

This flake sits alongside your other language templates:

```
nixos/flakes/
├── arduino/                 # C++ AVR microcontrollers
├── nanoframework/           # C# embedded devices (NEW)
├── rust/                    # Rust general development
├── embedded-rust/           # Rust microcontrollers
├── python/                  # Python scripting
├── java/                    # Java development
├── dotnet/                  # .NET desktop/server
├── tinygo/                  # Go for embedded
├── c/                       # C development
└── ...other templates
```

## Using the Template

### Option 1: Initialize a New Project (Copy Template)

```bash
# Go to a new directory
mkdir ~/my-nanoframework-project
cd ~/my-nanoframework-project

# Copy template files
cp -r /path/to/nanoframework/* .

# Or use nix init (once we add to flakes registry)
nix flake init -t path:/home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework
```

### Option 2: Use as Development Reference

```bash
# Enter the template environment directly
cd /home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework
nix develop

# Work and test there
make build
make detect
```

### Option 3: Reference from Your Project

If you have another flake that needs nanoFramework development:

**In your project's `flake.nix`:**

```nix
{
  description = "My embedded .NET project";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nanoframework.url = "path:../nanoframework";  # adjust path as needed
  };
  
  outputs = { self, nixpkgs, nanoframework, ... }:
    # Now you can reference nanoframework.devShells, etc.
}
```

## File Organization

The template is complete and self-contained:

```
nanoframework/
├── flake.nix              # Nix environment definition
├── .envrc                 # direnv support
├── NanoFrameworkApp.csproj  # C# project template
├── src/Program.cs         # Example C# code
├── scripts/               # Helper scripts for flashing/monitoring
├── Makefile               # Build/flash convenience targets
├── README.md              # Full documentation
├── QUICKSTART.md          # Hardware-specific guide
├── PROJECT_SUMMARY.md     # This overview
└── .gitignore             # Git configuration
```

## Customizing for New Projects

When creating a new project from this template:

1. **Update C# project name:**

   ```bash
   mv NanoFrameworkApp.csproj MyProject.csproj
   # Edit the .csproj to update namespaces
   ```

2. **Update your code:**

   ```bash
   # Edit src/Program.cs with your application logic
   ```

3. **Adjust for your board:**

   ```bash
   # In src/Program.cs, change LED_PIN for your board
   # Check QUICKSTART.md for pin numbers
   ```

## Testing the Template

```bash
cd /home/gooba42/Documents/Projects/nix/nixos/flakes/nanoframework

# 1. Test nix flake
nix flake check
nix flake show

# 2. Test dev environment
nix develop

# 3. Inside nix develop, test commands
which dotnet
which nanoff
make detect

# 4. Build example
make build

# 5. Exit
exit
```

## Git Integration

The template includes `.gitignore` for:

- `.envrc` (direnv config)
- `bin/`, `obj/` (build outputs)
- `.vscode/` (editor files)

You can safely commit to your nix repository:

```bash
cd /home/gooba42/Documents/Projects/nix
git add nixos/flakes/nanoframework/
git commit -m "Add .NET nanoFramework flake template for embedded development"
```

## Next: Add to Flakes Directory Index

To make this discoverable, you could update the flakes README:

```bash
# Check current flakes index
cat /home/gooba42/Documents/Projects/nix/nixos/flakes/README.md

# Update to mention nanoframework template
# This helps users discover it alongside other templates
```

## Cross-Reference with Other Templates

**This template shares philosophy with:**

- `arduino/` — Same hardware targets (ESP32, Pico)
- `embedded-rust/` — Same microcontroller platforms
- `dotnet/` — Same language (.NET/C#)

**Key differences:**

- `.NET nanoFramework` → Embedded systems only
- `arduino/` → C/C++ only
- `dotnet/` → Desktop/server (.NET)
- `embedded-rust/` → Rust instead of C#

## Maintenance Notes

### Keeping Up with Updates

nanoFramework releases often have:

- New board support targets
- Updated tooling (nanoff, extensions)
- NuGet package updates

To stay current:

```bash
# Inside nix develop
dotnet nuget locals all --clear
dotnet restore
nanoff --version  # Check if update available
```

### Flake Lock File

The template doesn't include `flake.lock` by design (keep it minimal for templates).

When you create a project from it:

```bash
nix flake update          # Generate flake.lock
git add flake.lock        # Commit to track nixpkgs version
```

---

## Summary

✅ **Complete template** for embedded .NET development
✅ **Multi-board support** (ESP32, ESP8266, RP Pico, STM32, Arduino)
✅ **Cross-platform** (Linux, macOS, Windows)
✅ **Well documented** (README, QUICKSTART, examples)
✅ **Ready to use** as-is or as starting point for custom projects
✅ **Integrated** with your nix flakes project structure

**Start here:** `QUICKSTART.md` for your specific hardware!
