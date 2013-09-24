$fn = 90;

// Dimensions
height = 4;
width = 30;
length = 80;
arm_width = 10;
arm_mount_hole_length = 1.6;   // Rectangular arm mounting hole width
arm_mount_hole_width = 3.5;    // Rectangular arm mounting hole length

module main() {
    leg();
}

module leg() {
    h_center_3 = -height * 3 / 2 + height / 2;
    h3 = height * 3;

    // Translate to draw the block centered as other pieces depend on this
    difference() {
        // Base plate
        translate([-length / 2, -width / 2, 0]) {
            cube([length, width, height]);
        }

        translate([-length / 4, 0, h_center_3]) {
            difference() {
                translate([0, -width / 2, 0])
                    cube([length - length / 4, width, h3]);
                scale([length - length / 4, width / 2, 1])
                    cylinder(r=1, h=h3);
            }
        }

        // Cutouts
        translate([-length / 2, 0, h_center_3]) {
            translate([length * 0.40, 0, 0])
                scale([length * 5 / length, width / 3, 1])
                    cylinder(r = 1, h3);

            translate([length * 0.60, 0, 0])
                scale([length * 5 / length, width / 4, 1])
                    cylinder(r = 1, h3);

            translate([length * 0.80, 0, 0])
                scale([length * 5 / length, width / 5, 1])
                    cylinder(r = 1, h3);
        }

        // Mounting holes
        #translate([-length / 2 + 5, -width / 2 + 7,  h_center_3]) {
            cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
            translate([arm_width + arm_mount_hole_length, 0, 0])
                cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
        }

        #translate([-length / 2 + 5, width / 2 -7 - arm_mount_hole_width,  h_center_3]) {
            cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
            translate([arm_width + arm_mount_hole_length, 0, 0])
                cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
        }
    }
}

// Makes a cylinder with diameter the specified diameter and height
module hole(d, h) {
    cylinder(r=d / 2, h=h);
}

main();