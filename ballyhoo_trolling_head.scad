$fn = 140;

//====================
// USER PARAMETERS
//====================

overall_length = 59.7;
nose_length = 37.5;
rear_length = 22.2;
max_diameter = 19.05;
tip_diameter = 4.8;
line_hole = 2.0;
eye_diameter = 6.5;
eye_depth = 1.5;
pocket_diameter = 15.8;
pocket_depth = 16.5;
retaining_ring_width = 3.0;
ring_height = 1.2;
water_port = 3.5;

//====================
// MAIN BODY
//====================

module head_body() {
    difference() {
        union() {
            // Nose
            translate([0, 0, 0])
                rotate([0, 90, 0])
                    cylinder(
                        h = nose_length,
                        r1 = tip_diameter / 2,
                        r2 = max_diameter / 2
                    );

            // Rear body
            translate([nose_length, 0, 0])
                rotate([0, 90, 0])
                    cylinder(
                        h = rear_length,
                        r = max_diameter / 2
                    );

            // Retaining ring
            translate([overall_length - retaining_ring_width, 0, 0])
                rotate([0, 90, 0])
                    cylinder(
                        h = retaining_ring_width,
                        r = max_diameter / 2 + ring_height
                    );
        }

        // Center bore
        translate([-1, 0, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = overall_length + 2,
                    r = line_hole / 2
                );
    }
}

head_body();
