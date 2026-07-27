$fn = 140;

//====================
// USER PARAMETERS
//====================

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
nose_sections = 14;
// Height of each cylindrical slice used to hull the nose profile.
hull_slice_height = 0.6;
// Lower values soften the curve; higher values steepen the taper.
nose_curve_exponent = 0.65;
// Extra length to extend the center bore beyond the model ends (mm).
bore_extension = 1;

//====================
// DERIVED VALUES
//====================

safe_nose_sections = max(nose_sections, 2);
// Computed from the nose and rear body lengths.
overall_length = nose_length + rear_length;
section_spacing = nose_length / (safe_nose_sections - 1);

function section_x_offset(section_index) = section_index * section_spacing;

// Returns the nose radius at a section index along the rounded profile.
function nose_radius(section_index) =
    (tip_diameter / 2) +
    ((max_diameter - tip_diameter) / 2) *
    pow(section_index / (safe_nose_sections - 1), nose_curve_exponent);

module nose_section(section_index) {
    translate([
        section_x_offset(section_index),
        0,
        0
    ])
        rotate([0, 90, 0])
            cylinder(
                h = hull_slice_height,
                r = nose_radius(section_index)
            );
}

module rounded_nose() {
    difference() {
        union() {
            // Blend multiple cross-sections to form
            // a smooth trolling-head profile.
            // Loop pairs adjacent sections (i with i + 1) to build the profile.
            for (i = [0:safe_nose_sections - 2]) {
                hull() {
                    nose_section(i);
                    nose_section(i + 1);
                }
            }
        }

        // Center line passage
        translate([-bore_extension, 0, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = nose_length + (bore_extension * 2),
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
        translate([-bore_extension, 0, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = overall_length + (bore_extension * 2),
                    r = line_hole / 2
                );
    }
}

head_body();
