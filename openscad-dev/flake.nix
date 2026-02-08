# flakes/openscad-dev/flake.nix — OpenSCAD development environment flake
# Purpose:
#   Provides a Nix development environment for OpenSCAD 3D CAD modeling with necessary
#   tools for viewing, rendering, and exporting 3D models.
# How to use:
#   - Enter devShell: nix develop
#   - Run example: openscad src/example.scad
#   - Render to STL: openscad -o output.stl src/example.scad
{
  description = "A Nix-flake-based OpenSCAD development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # OpenSCAD - 3D CAD modeler
              openscad

              # Optional: mesh processing tools
              meshlab # Mesh viewer/editor
              openscad-lsp # Language server for OpenSCAD (IDE support)

              # Version control
              git
            ];
            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              echo "[openscad-template] Welcome to the OpenSCAD dev shell!"
              echo "Tools: openscad, meshlab, openscad-lsp"
              echo "Run 'openscad src/example.scad' to view the example model."
              echo "Run 'make render' to export models to STL. See README.md for usage."
            '';
          };
        }
      );
    };
}
