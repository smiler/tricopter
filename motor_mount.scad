$fn = 90;

// Dimensions
motor_base_height = 3;          // Height of motor mount base
motor_mount_diameter = 32;      // Diameter of motor mounting base
motor_mount_hole = 3.3;         // Diameter of motor mounting holes
motor_center_hole_diameter = 10; // Diameter of center hole. Set to 0 to disable

module main() {
    translate([0, 25, 0]) {
        !motor_mount(motor_center_hole_diameter);
    }

    translate([0, -25, 0]) {
        motor_mount(0);
    }
}

module motor_mount(center_hole) {
    h_center_3 = -motor_base_height * 3 / 2 + motor_base_height / 2;
    h3 = motor_base_height * 3;
    // distance = motor_mount_hole_spacing / 2;

    difference() {
        // Base plate
        cylinder(r=motor_mount_diameter / 2, h=motor_base_height);

        // Mounting holes
        translate([8, 0, h_center_3])
            hole(motor_mount_hole, h3);
        translate([-8, 0, h_center_3])
            hole(motor_mount_hole, h3);
        translate([0, 9.5, h_center_3])
            hole(motor_mount_hole, h3);
        translate([0, -9.5, h_center_3])
            hole(motor_mount_hole, h3);

        // Center hole
        if (center_hole > 0) {
            translate([0, 0, h_center_3])
                hole(motor_center_hole_diameter, h3);
        }
    }
}

// Makes a cylinder with diameter the specified diameter and height
module hole(d, h) {
    cylinder(r=d / 2, h=h);
}

main();