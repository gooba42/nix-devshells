// flakes/openscad-dev/src/example.scad — Simple OpenSCAD example model
// Purpose:
//   Demonstrates basic OpenSCAD syntax with a simple 3D object.
//   This creates a cube with a cylindrical hole through it.

// Parameters
cube_size = 20;
hole_diameter = 10;
$fn = 50; // Smoother circles

// Main model
difference() {
    // Create a cube
    cube([cube_size, cube_size, cube_size], center = true);

    // Subtract a cylinder (hole) through the center
    rotate([0, 90, 0])
        cylinder(h = cube_size + 2, d = hole_diameter, center = true);
}

// Add a small sphere on top
translate([0, 0, cube_size/2 + 5])
    sphere(d = 8);
