$fn = 90;

height = 2.6;           // Height of plate
boom_size = 10;         // Width of arms (square arms assumed)
hole_diameter = 3.3;    // Diameter of holes. I use 3.3 for my 3mm holes
                        // as my printer tends to shrink them by about 10%.

// Center of gravity
cog = [50, 56];     // Center of gravity (CoG) coordinates
cog_hole = 1;       // Diameter of hole at CoG. 0 To disable.

// Tail support settings
use_tail_support = true;
support_width = 10;                 // Width of tail support
support_length = 20;                // Length of tail support
support_spacing = boom_size + 0.35; // Spacing between support elements
support_height = boom_size / 2.5;     // Height of tail support

use_cable_hole = true;  // Whether to draw cable routing hole or not

// Drawing options
draw_booms = true;
draw_cog = true;

// Often used calculations to center holes in Z
h_center_3 = -height * 3 / 2 + height / 2;
h3 = height * 3;

main();

module main() {
    difference() {
        make_hull();
        make_holes();
    }

    if (draw_booms) {
        // Top support
        %translate([30, 130, height])
            rotate(a=-90, v=[0, 0, 1])
                cube([boom_size, 40, boom_size]);

        // Tail arm
        %translate([50 -boom_size / 2, -10, height])
            cube([boom_size, 60, boom_size]);
    }

    // Draw center of gravity
    if (draw_cog) {
        %draw_cog();
    }
}

module make_hull() {
    difference() {
        union() {
            cube([100, 130, height]);

            if (use_tail_support) {
                tail_support();
            }
        }

        // Cut outline
        hull() {
            translate([20, 0, h_center_3])
                cube([10, 15, h3]);
            translate([-40, 15, h_center_3])
                cylinder(r=70, h=h3);
        }

        hull() {
            translate([70, 0, h_center_3])
                cube([10, 15, h3]);
            translate([140, 15, h_center_3])
                cylinder(r=70, h=h3);
        }

        translate([0, 95, h_center_3]) {
            hull() {
                cube([10, 35, h3]);

                rotate(a=-30, v=[0, 0, 1]) {
                    translate([22, 7.3, 0]) {
                        cylinder(r=7.3, h=h3);

                        rotate(a=30, v=[0, 0, 1])
                            cube([7.3, 40, h3]);
                    }
                }
            }
        }

        mirror([1, 0, 0]) {
            translate([-100, 95, h_center_3]) {
                hull() {
                    cube([10, 35, h3]);

                    rotate(a=-30, v=[0, 0, 1]) {
                        translate([22, 7.3, 0]) {
                            cylinder(r=7.3, h=h3);

                            rotate(a=30, v=[0, 0, 1])
                                cube([7.3, 40, h3]);
                        }
                    }
                }
            }
        }

        difference() {
            translate([30, 125, h_center_3])
                cube([5, 5, h3]);
            translate([35, 125, h_center_3])
                cylinder(r = 5, h = h3);
        }

        difference() {
            translate([65, 125, h_center_3])
                cube([5, 5, h3]);
            translate([65, 125, h_center_3])
                cylinder(r = 5, h = h3);
        }

        difference() {
            translate([30, 0, h_center_3])
                cube([5, 5, h3]);
            translate([35, 5, h_center_3])
                cylinder(r = 5, h = h3);
        }

        difference() {
            translate([65, 0, h_center_3])
                cube([5, 5, h3]);
            translate([65, 5, h_center_3])
                cylinder(r = 5, h = h3);
        }
    }
}

module make_holes() {
    // Translate to CoG and make arm holes from there
    translate(cog) {
        rotate(a=60, v=[0, 0, 1])
            translate([0, 38, 0])
                front_arm_holes();

        mirror([1, 0, 0])
            rotate(a=60, v=[0, 0, 1])
                translate([0, 38, 0])
                    front_arm_holes();

        translate([0, -38, h_center_3])
            hole(hole_diameter);
    }

    // Tail holes
    translate([40, 10, h_center_3]) {
        hole(hole_diameter, h3 + support_height);
    }
    translate([60, 10, h_center_3]) {
        hole(hole_diameter, h3 + support_height);
    }

    // Front holes
    translate([40, 130 - boom_size - hole_diameter / 2 , h_center_3])
        hole(hole_diameter);
    translate([60, 130 - boom_size - hole_diameter / 2, h_center_3])
        hole(hole_diameter);

    // Cable routing hole
    if (use_cable_hole) {
        translate([50, 90, h_center_3])
            scale([1.5, 2])
                cylinder(r=5, h=h3);
    }

    // Center of gravity hole
    if (cog_hole > 0) {
        translate([cog[0], cog[1], -height * 3 / 2 + height / 2])
            hole(r=cog_hole, h=height * 3);
    }
}

module tail_support() {
    translate([50, 0, height]) {
        translate([-support_spacing / 2 - support_width, 0, 0])
            cube([support_width, support_length, support_height]);

        translate([support_spacing / 2, 0, 0])
            cube([support_width, support_length, support_height]);
    }
}

module front_arm_holes() {
    // Center hole
    translate([0, 0, h_center_3])
        hole(hole_diameter);

    // Support hole
    translate([-boom_size / 2 - hole_diameter / 2, -20, h_center_3])
        hole(hole_diameter);

    // Draw front arms here because we are in the correct coordinate system already
    if (draw_booms) {
        %translate([-boom_size / 2, -30, height])
            cube([boom_size, 60, boom_size]);
    }
}

// Makes a cylinder at center of gravity
module draw_cog() {
    translate([cog[0], cog[1], -height * 3 / 2 + height / 2])
        cylinder(r=1, h=height * 3);
}

// Makes a cylinder with diameter the specified diameter and height
module hole(d, h=h3) {
    cylinder(r=d / 2, h=h);
}