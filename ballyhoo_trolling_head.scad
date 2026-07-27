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

//====================
// SKIRT POCKET
//====================

pocket_depth = 16.5;
pocket_ID = 15.8;
entry_taper = 3.0;
wall_thickness = 1.6;

ring_width = 3.0;
ring_height = 1.2;
taper_radius_reduction = 2.0;
cutout_overlap = 1.0;
water_port = 3.5;
nose_section_count = 14;
// Height of each cylindrical slice used to hull the nose profile.
hull_slice_height = 0.6;
// Lower values soften the curve; higher values steepen the taper (typical range 0.3-2.0).
nose_curve_exponent = 0.65;
// Extra length to extend the center bore beyond the model ends (mm).
bore_extension = 1;

//====================
// DERIVED VALUES
//====================

// At least 2 sections are required to create one hull segment from i to i + 1.
safe_nose_sections = max(nose_section_count, 2);
// Computed from the nose and rear body lengths.
overall_length = nose_length + rear_length;
section_spacing = nose_length / (safe_nose_sections - 1);

if (nose_section_count < 2) {
    echo("nose_section_count must be at least 2; using safe_nose_sections = 2.");
}

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
            // a smooth trolling head profile.
            // Loop through adjacent section pairs (i with i + 1) to build the profile.
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

/////////////////////////////////////////////////////
// Rear Body with Skirt Pocket
/////////////////////////////////////////////////////

module rear_body() {
    difference() {
        union() {
            // Rear outside body
            translate([nose_length, 0, 0])
                rotate([0, 90, 0])
                    cylinder(
                        h = rear_length,
                        r = max_diameter / 2
                    );

            // Retaining ring
            translate([
                overall_length - ring_width,
                0,
                0
            ])
                rotate([0, 90, 0])
                    cylinder(
                        h = ring_width,
                        r = max_diameter / 2 + ring_height
                    );
        }

        // Skirt pocket
        translate([
            overall_length - pocket_depth,
            0,
            0
        ])
            rotate([0, 90, 0])
                cylinder(
                    h = pocket_depth + cutout_overlap,
                    r = pocket_ID / 2
                );

        // Lead-in taper
        translate([
            overall_length - pocket_depth - entry_taper,
            0,
            0
        ])
            rotate([0, 90, 0])
                cylinder(
                    h = entry_taper,
                    r1 = (pocket_ID / 2) - taper_radius_reduction,
                    r2 = pocket_ID / 2
                );
    }
}

//====================
// MAIN BODY
//====================

module head_body() {
    difference() {
        union() {
            // Rounded Nose
            rounded_nose();
            rear_body();
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
