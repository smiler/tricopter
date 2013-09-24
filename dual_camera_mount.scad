$fn = 90;

base_height = 3; // Height of base plate

plate_width = 40;       // Width of plate that holder will be mounted on.
plate_hole_offset  = 2; // I use small cutouts on my plate to prevent slipping.
                        // The value here will be substracted from the
                        // platewidth when calucalting hole position.

gopro_angle = 15; // Angle of gopro mount plate

zip_hole_height = 1.6; // Zip tie mounting hole width
zip_hole_width = 3.5;  // Zip tie mounting hole length

main();

module main() {
    union() {
        base_plate();

        translate([0, 0, base_height])
            gopro_mount();
    }
}

module base_plate() {
    gopro_width = 60;
    ccd_width = 34;
    spacing = 3;
    total_width = gopro_width + spacing + ccd_width;
    difference() {
        union() {
            // Base
            cube([total_width, 30, base_height]);

            // Mounting tounges
            translate([45 - plate_width / 2, 0, 0]) { // Will center the lens ontop of the plate
                // Upper
                #translate([-zip_hole_height * 2, 30 - 0.2, 0]) {
                    difference() {
                        // Plate
                        cube([plate_width + zip_hole_height * 4, 10 + 0.2, base_height]);

                        // Holes
                        translate([0, (10 - zip_hole_width) / 2, -0.2]) {

                            // Left
                            translate([zip_hole_height + plate_hole_offset, 0, 0])
                                cube([zip_hole_height, zip_hole_width, base_height + 0.4]);

                            // Right
                            translate([plate_width + zip_hole_height * 2 - plate_hole_offset, 0, 0])
                                cube([zip_hole_height, zip_hole_width, base_height + 0.4]);
                        }
                    }
                }

                // Lower
                translate([-zip_hole_height * 2, -10, 0]) {
                    difference() {
                        // Plate
                        cube([plate_width + zip_hole_height * 4, 10 + 0.2, base_height]);

                        // Holes
                        translate([0, (10 - zip_hole_width) / 2, -0.2]) {

                            // Left
                            translate([zip_hole_height + plate_hole_offset, 0, 0])
                                cube([zip_hole_height, zip_hole_width, base_height + 0.4]);

                            // Right
                            translate([plate_width  - plate_hole_offset + zip_hole_height * 2, 0, 0])
                                cube([zip_hole_height, zip_hole_width, base_height + 0.4]);
                        }
                    }
                }

            }
        }

        // CCD holes
        translate([gopro_width + spacing, 0, 0]) { // Offset to put CCD right of gopro
            // Upper
            translate([2, 20, -0.2]) { // Offset for left CCD mounting hole
                cube([zip_hole_width, zip_hole_height, base_height + 0.4]);
                translate([23, 0, 0]) { // Right
                    cube([zip_hole_width, zip_hole_height, base_height + 0.4]);
                }
            }

            // Lower
            translate([2, 8, -0.2]) { // Offset for left CCD mounting hole
                cube([zip_hole_width, zip_hole_height, base_height + 0.4]);
                translate([23, 0, 0]) { // Right
                    cube([zip_hole_width, zip_hole_height, base_height + 0.4]);
                }
            }
        }
    }
}

module gopro_mount() {
    gopro_width = 60;
    gopro_depth = 30;
    strap_width = 16;
    strap_height = 2;
    strap_offset = 18; // Offset from left to beginning strap cutout
    difference() {
        cube([gopro_width, gopro_depth, gopro_depth]);

        translate([-0.5, 0, 4]) {
            rotate(a = gopro_angle, v = [1, 0, 0])
                cube([gopro_width + 1, gopro_depth * 2, gopro_depth]);
        }

        translate([strap_offset, -0.2, -0.2])
            cube([strap_width, gopro_depth + 0.4, strap_height + 0.2]);
    }
}

module gopro_holder() {
    difference() {
        cube([64, 34, 4]);

        translate([2, 2, 2])
            cube([60, 30, 10]);
    }
}