# Makefile for OpenSCAD project
# Purpose:
#   Provides common tasks for viewing, rendering, and exporting OpenSCAD models.

.PHONY: help view render clean

# Default target
help:
	@echo "OpenSCAD Development Tasks:"
	@echo "  make view      - Open example model in OpenSCAD GUI"
	@echo "  make render    - Render example.scad to STL"
	@echo "  make png       - Export preview as PNG image"
	@echo "  make clean     - Remove generated files"

# Open model in OpenSCAD GUI
view:
	openscad src/example.scad

# Render to STL for 3D printing
render:
	@mkdir -p output
	openscad -o output/example.stl src/example.scad
	@echo "Rendered to output/example.stl"

# Export preview as PNG
png:
	@mkdir -p output
	openscad -o output/example.png --imgsize=800,600 src/example.scad
	@echo "Exported preview to output/example.png"

# Clean generated files
clean:
	rm -rf output/
	@echo "Cleaned output directory"
