$fn = 140;

//====================
// USER PARAMETERS
//====================

nose_length = 37.5;
rear_length = 22.2;
max_diameter = 19.05;
tip_diameter = 4.8;
line_hole = 2.0;

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
nose_profile_sections = 14;
// Axial length of each cylindrical slice used to hull the nose profile.
nose_hull_slice_height = 0.6;
// Lower values soften the curve; higher values steepen the taper (typical range 0.3-2.0).
nose_curve_exponent = 0.65;
// Extra length to extend the center bore beyond the model ends (mm).
bore_extension = 1;

/////////////////////////////////////////////////////
// PART 4 PARAMETERS
/////////////////////////////////////////////////////

eye_diameter = 6.5;
eye_depth = 1.5;

eye_position_x = 27.0;
eye_position_y = 7.6;

water_port_diameter = 3.5;
water_port_angle = 28;
water_port_position_x = 33.5;
water_port_position_y = 6.0;
water_port_height = 25;

//====================
// DERIVED VALUES
//====================

// At least 2 sections are required to create one hull segment from i to i + 1.
validated_nose_sections = max(nose_profile_sections, 2);
// Computed from the nose and rear body lengths.
overall_length = nose_length + rear_length;
section_spacing = nose_length / (validated_nose_sections - 1);

if (nose_profile_sections < 2) {
    echo("nose_profile_sections must be at least 2; enforcing a minimum of 2.");
}

function section_x_offset(section_index) = section_index * section_spacing;

// Returns the nose radius at a section index along the rounded profile.
function nose_radius(section_index) =
    (tip_diameter / 2) +
    ((max_diameter - tip_diameter) / 2) *
    pow(section_index / (validated_nose_sections - 1), nose_curve_exponent);

module nose_section(section_index) {
    translate([
        section_x_offset(section_index),
        0,
        0
    ])
        rotate([0, 90, 0])
            cylinder(
                h = nose_hull_slice_height,
                r = nose_radius(section_index)
            );
}

module rounded_nose() {
    // Blend multiple cross-sections to form
    // a smooth trolling head profile.
    // Loop through adjacent section pairs (i with i + 1) to build the profile.
    for (i = [0:validated_nose_sections - 2]) {
        hull() {
            nose_section(i);
            nose_section(i + 1);
        }
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

/////////////////////////////////////////////////////
// Eye Recesses
/////////////////////////////////////////////////////

module eye_recesses() {
    for (side = [-1, 1]) {
        translate([eye_position_x, side * eye_position_y, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = eye_depth,
                    r = eye_diameter / 2
                );
    }
}

/////////////////////////////////////////////////////
// Water Ports
/////////////////////////////////////////////////////

module water_ports() {
    for (side = [-1, 1]) {
        translate([water_port_position_x, side * water_port_position_y, 0])
            rotate([0, -side * water_port_angle, 90])
                cylinder(
                    h = water_port_height,
                    r = water_port_diameter / 2,
                    center = true
                );
    }
}

module head_body() {
    difference() {
        union() {
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

        // Eye recesses
        eye_recesses();

        // Water ports
        water_ports();
    }
}

head_body();
