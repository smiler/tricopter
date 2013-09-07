$fn = 90;

// Dimensions
motor_base_height = 5;          // Height of motor mount base
motor_mount_width = 41;         // Width of motor mount base
motor_mount_hole = 3.2;         // Diameter of motor mounting holes
motor_mount_hole_spacing = 34;  // Diameter between motor mounting holes (center to center)
motor_center_hole_diameter = 0; // Diameter of center hole. Set to 0 to disable

arm_base_height = 3;          // Height of arm base
arm_base_width = 20;          // Width of arm base
arm_base_length = 36;         // Length of arm base
arm_mount_hole_width = 1.6;   // Rectangular arm mounting hole width
arm_mount_hole_length = 3.5;  // Rectangular arm mounting hole length

hinge_base_width = 12;       // Width and length of hinge base
hinge_base_height = 7;       // Height of hinge base
motor_hinge_base_height = 9; // Height of hinge on motor mounts
hinge_base_play = 0.4;       // Play between hinge interlock.
hinge_pin_diameter = 4.1;    // Diameter of hinge pin. Used as radius for the smaller hole
hinge_pin_outer_hole = 4.3;  // Diameter of the larger hinge pin hole

servo_mount_support_height = 4;

module main() {
    // Motor mount part
    translate([0, 25, 0]) {
        union() {
            motor_mount();
            difference() {
                union() {
                    translate([-hinge_base_width * 1.5, 0, motor_base_height])
                        hinge(hinge_pin_diameter, motor_hinge_base_height);
                    translate([hinge_base_width * 1.5 - hinge_base_width, 0, motor_base_height]) {
                        servo_mount_support();
                        hinge(hinge_pin_diameter, motor_hinge_base_height);
                    }
                }

                // Play cutout
                translate([-hinge_base_width / 2 - hinge_base_play / 2 , -hinge_base_width * 4 / 6, motor_base_height])
                    cube([hinge_base_width + hinge_base_play, hinge_base_width * 4 / 3, hinge_base_width * 4/3]);

                // Cutout for zip-tie spacing on arm mount
                // translate([0 , -hinge_base_width * 4 / 6, motor_base_height])
                //     #cube([10, 10, 10]);                    
            }
        }
    }

    // Arm part
    translate([0, -25, 0]) {
        union() {
            arm_mount();
            difference() {
                union() {
                    translate([-hinge_base_width * 1.5, 0, arm_base_height])
                        hinge(hinge_pin_outer_hole);
                    translate([hinge_base_width * 0.5, 0, arm_base_height])
                        hinge(hinge_pin_outer_hole);
                }

                translate([-hinge_base_width / 2 - hinge_base_play / 2 , -hinge_base_width * 4 / 6, arm_base_height])
                    cube([hinge_base_width + hinge_base_play, hinge_base_width * 4 / 3, hinge_base_width * 4/3]);
            }
        }
    }
}

module motor_mount() {
    h_center_3 = -motor_base_height * 3 / 2 + motor_base_height / 2;
    h3 = motor_base_height * 3;
    distance = motor_mount_hole_spacing / 2;

    difference() {
        // Base plate
        //cylinder(r=motor_mount_width / 2, h=motor_base_height);
        translate([-(hinge_base_width  * 1.5), -motor_mount_width /2 + 4, 0])
            cube([hinge_base_width * 3, motor_mount_width -8, motor_base_height]);

        // Cutout
        translate([0 , motor_mount_width, h_center_3])
            cylinder(r=28, h=h3);
        translate([0 , -motor_mount_width, h_center_3])
            cylinder(r=28, h=h3);

        // Mounting holes
        rotate(a=45, v=[0, 0, 1]) {
            translate([-distance, 0, h_center_3])
                hole(motor_mount_hole, h3);
            translate([distance, 0, h_center_3])
                hole(motor_mount_hole, h3);
            translate([0, distance, h_center_3])
                hole(motor_mount_hole, h3);
            translate([0, -distance, h_center_3])
                hole(motor_mount_hole, h3);
        }        

        // Center hole
        if (motor_center_hole_diameter > 0) {
            translate([0, 0, h_center_3])
                hole(motor_center_hole_diameter, h3);
        }
    }
}

module arm_mount() {
    h_center_3 = -arm_base_height * 3 / 2 + arm_base_height / 2;
    h3 = arm_base_height * 3;

    // Translate to draw the block centered as other pieces depend on this
    difference() {
        // Base plate
        translate([-arm_base_length / 2, -arm_base_width / 2, 0]) {
            cube([arm_base_length, arm_base_width, arm_base_height]);
        }

        // Mounting holes
        translate([-3/2 - hinge_base_width, -hinge_base_width / 2 - arm_mount_hole_width,  h_center_3])
            cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
        translate([-3/2 - hinge_base_width, hinge_base_width / 2, h_center_3])
            cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
        translate([-3/2 + hinge_base_width, -hinge_base_width / 2 - arm_mount_hole_width, h_center_3])
            cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
        translate([-3/2 + hinge_base_width, hinge_base_width / 2, h_center_3])
            cube([arm_mount_hole_length, arm_mount_hole_width, h3]);
    }
}

module hinge(pin_diameter, height = hinge_base_height) {
    width = hinge_base_width;
    //height = hinge_base_height;
    translate([0, -width / 2, 0])
        difference() {
            // Hinge support
            union() {
                cube([width, width, height / 2]);
                translate([0, width /2, height / 2])
                    rotate(a=90, v=[0, 1, 0])
                        cylinder(r=width / 2, h=width);
            }

            // Pin hole
            translate([-width * 1/3, width /2, height / 2])
                translate([0, 0, width / 2 - pin_diameter])
                    rotate(a=90, v=[0, 1, 0])
                        cylinder(r=pin_diameter / 2, h=width + width * 2/3);
        }
}

module servo_mount_support() {
    width = hinge_base_width + 6;
    translate([+hinge_base_play / 2, -width / 2,0]) {
        //cube([hinge_base_width - hinge_base_play / 2, width, 2.5]);
        cube([hinge_base_width - hinge_base_play / 2, width, servo_mount_support_height]);
    }
}

// Makes a cylinder with diameter the specified diameter and height
module hole(d, h) {
    cylinder(r=d / 2, h=h);
}

main();