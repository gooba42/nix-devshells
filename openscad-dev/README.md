# OpenSCAD Development Template

A Nix-flake-based development environment for OpenSCAD 3D CAD modeling.

## Quick Start

```bash
# Clone or copy this template
cd openscad-dev

# Enter the development environment
nix develop

# View the example model in OpenSCAD GUI
openscad src/example.scad

# Or use the Makefile
make view
```

## What's Included

This template provides:

- **OpenSCAD**: The main 3D CAD modeling software
- **MeshLab**: Mesh viewer and editor for post-processing
- **OpenSCAD LSP**: Language server for IDE support (syntax highlighting, completion)

## Project Structure

```
openscad-dev/
├── flake.nix           # Nix flake configuration
├── shell.nix           # Legacy nix-shell support
├── Makefile            # Common build tasks
├── project.toml        # Project metadata
├── src/
│   └── example.scad    # Example OpenSCAD model
└── output/             # Rendered/exported files (gitignored)
```

## Build and Run

### View Models

```bash
# Open in OpenSCAD GUI
make view

# Or directly
openscad src/example.scad
```

### Render to STL (for 3D printing)

```bash
# Render example model
make render

# Or directly
openscad -o output/example.stl src/example.scad
```

### Export Preview Image

```bash
# Export as PNG
make png

# Or with custom size
openscad -o output/preview.png --imgsize=1920,1080 src/example.scad
```

### Headless Rendering

For CI/CD or batch processing:

```bash
# Render without GUI (headless)
openscad -o output/model.stl --render src/example.scad
```

## Project Metadata

See [project.toml](project.toml) for project information. Update the name, version, and authors for your project.

## Customization

### Adding Libraries

OpenSCAD supports external libraries. To include SCAD libraries in your project:

1. Add library files to a `lib/` directory
2. Use `use <lib/mylib.scad>` in your models
3. Consider adding the library as a Nix package if it's available in nixpkgs

### Modifying the DevShell

Edit [flake.nix](flake.nix) to add more tools:

```nix
packages = with pkgs; [
  openscad
  meshlab
  openscad-lsp
  # Add more tools here:
  prusa-slicer  # 3D printing slicer
  blender       # Advanced 3D modeling
];
```

### Using OpenSCAD Libraries from Nixpkgs

Some OpenSCAD libraries are available in nixpkgs. For example, to use BOSL2 (Belfry OpenSCAD Library v2):

```nix
packages = with pkgs; [
  openscad
  openscad-unstable  # Sometimes has newer library support
  # Note: Check nixpkgs for available OpenSCAD libraries
];
```

## Packaging for Nixpkgs

To package an OpenSCAD project for distribution via Nixpkgs:

1. Create a `default.nix` that outputs the rendered STL/3MF files
2. Use `stdenv.mkDerivation` with `openscad` as a build input
3. Run `openscad -o $out/model.stl --render src/model.scad` in the build phase
4. Refer to the [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/) for packaging guidelines

Example `default.nix`:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "my-openscad-models";
  src = ./.;

  nativeBuildInputs = [ pkgs.openscad ];

  buildPhase = ''
    mkdir -p $out
    openscad -o $out/model.stl --render src/example.scad
  '';

  installPhase = ''
    # Models already in $out from buildPhase
  '';
}
```

## Legacy Usage (without flakes)

For users not using flakes:

```bash
# Enter shell with nix-shell
nix-shell

# Then use OpenSCAD as normal
openscad src/example.scad
```

## Resources

- [OpenSCAD Documentation](https://openscad.org/documentation.html)
- [OpenSCAD Cheat Sheet](https://openscad.org/cheatsheet/)
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)
- [OpenSCAD on Nixpkgs](https://search.nixos.org/packages?query=openscad)

## Tips

- Use `$fn = 50;` or higher for smoother circles/curves (higher values = longer render times)
- Test with preview mode (F5) before full render (F6) for faster iteration
- Use `render()` function to force full geometry calculation for specific objects
- Consider using parametric design with variables for easy customization
- Export to STL for 3D printing, STEP/IGES for CAD interoperability

## License

MIT (or adjust as needed for your project)
