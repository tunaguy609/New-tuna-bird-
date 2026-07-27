$fn = 140;

//====================
// USER PARAMETERS
//====================

nose_length = 37.5;
rear_length = 22.2;
overall_length = nose_length + rear_length;

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
nose_sections = 14;
section_height = 0.6;
nose_curve_exponent = 0.65;

module rounded_nose() {
    difference() {
        union() {
            // Blend multiple cross-sections to form
            // a smooth trolling-head profile.
            for (i = [0:nose_sections - 2]) {
                hull() {
                    translate([
                        i * (nose_length / (nose_sections - 1)),
                        0,
                        0
                    ])
                        rotate([0, 90, 0])
                            cylinder(
                                h = section_height,
                                r =
                                    (tip_diameter / 2) +
                                    ((max_diameter - tip_diameter) / 2) *
                                    pow(i / (nose_sections - 1), nose_curve_exponent)
                            );

                    translate([
                        (i + 1) * (nose_length / (nose_sections - 1)),
                        0,
                        0
                    ])
                        rotate([0, 90, 0])
                            cylinder(
                                h = section_height,
                                r =
                                    (tip_diameter / 2) +
                                    ((max_diameter - tip_diameter) / 2) *
                                    pow((i + 1) / (nose_sections - 1), nose_curve_exponent)
                            );
                }
            }
        }

        // Center line passage
        translate([-1, 0, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = nose_length + 2,
                    r = line_hole / 2
                );
    }
}

//====================
// MAIN BODY
//====================

module head_body() {
    difference() {
        union() {
            // Nose
            rounded_nose();

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
