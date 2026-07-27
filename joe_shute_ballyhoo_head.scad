// ============================================================
//  Joe Shute Style Ballyhoo Skirt Head
//  Parametric trolling lure head – OpenSCAD
// ============================================================
//
//  A Joe Shute is a classic offshore trolling lure head used
//  to rig a ballyhoo baitfish.  Key features:
//    • Elongated bullet / tapered-cylinder body
//    • Flat (or slightly cupped) front face
//    • Center through-wire rigging hole
//    • Rear skirt collar groove that locks the skirt in place
//    • Optional chin-weight flat on the bottom
//
//  All dimensions in millimetres.
//  Print in resin or machine from aluminium / stainless steel.
// ============================================================

// ── Adjustable parameters ────────────────────────────────────

// Overall head length (nose tip to rear skirt seat)
head_length     = 50;       // mm  (~2 in)

// Maximum body diameter (at the widest point near the rear)
head_diameter   = 22;       // mm  (~7/8 in)

// Nose taper length – how far back the point runs
nose_length     = 18;       // mm

// Nose tip diameter (small but not zero to keep the shape clean)
nose_tip_dia    = 3;        // mm

// Front face cup depth (0 = flat face; >0 = concave cup)
cup_depth       = 1.5;      // mm

// Cup mouth diameter  (should be <= head_diameter)
cup_dia         = 14;       // mm

// Center through-wire hole diameter
wire_hole_dia   = 2.5;      // mm  (fits 49-strand cable or heavy mono)

// ── Skirt collar parameters ──────────────────────────────────

// Length of the cylindrical skirt seat at the rear
collar_length   = 8;        // mm

// Collar OD – slightly narrower than body so skirt slides over
collar_dia      = head_diameter - 3;  // mm

// Groove width & depth cut into the collar for the skirt ring
groove_width    = 2.5;      // mm
groove_depth    = 1.5;      // mm

// ── Chin-weight flat (optional) ─────────────────────────────
// Set chin_flat = true to add a flat on the underside of the
// taper, which biases the lure to run keel-down.
chin_flat       = true;
chin_flat_depth = 3;        // mm below centre line

// ── Render detail ────────────────────────────────────────────
$fn = 72;   // facet count – increase for smoother curves

// ============================================================
//  Modules
// ============================================================

// Body: a tapered cylinder (frustum) blending nose tip → body dia
module body() {
    cylinder_length = head_length - collar_length;

    hull() {
        // Rear (wide) end of the tapered body
        translate([0, 0, collar_length])
            cylinder(h = 0.01, d = head_diameter, center = false);

        // Nose tip
        translate([0, 0, head_length - nose_tip_dia / 2])
            sphere(d = nose_tip_dia);
    }
}

// Skirt collar – cylindrical seat at the rear end
module skirt_collar() {
    difference() {
        cylinder(h = collar_length, d = collar_dia, center = false);

        // Skirt-locking groove
        groove_z = collar_length * 0.5 - groove_width / 2;
        translate([0, 0, groove_z])
            difference() {
                cylinder(h = groove_width,
                         d = collar_dia + 0.02,   // full width cut
                         center = false);
                cylinder(h = groove_width,
                         d = collar_dia - groove_depth * 2,
                         center = false);
            }
    }
}

// Front face cup (concave recess on the nose face)
module face_cup() {
    if (cup_depth > 0) {
        translate([0, 0, head_length - cup_depth])
            sphere(d = cup_dia);
    }
}

// Through-wire hole – runs full length of the lure on centre
module wire_hole() {
    translate([0, 0, -1])
        cylinder(h = head_length + 2, d = wire_hole_dia, center = false);
}

// Chin flat – planar cut on the underside of the nose taper
module chin_flat_cut() {
    if (chin_flat) {
        translate([-head_diameter, -(head_diameter / 2 + chin_flat_depth),
                   collar_length])
            cube([head_diameter * 2,
                  head_diameter,
                  head_length - collar_length + 1]);
    }
}

// ============================================================
//  Assembly
// ============================================================

difference() {
    union() {
        skirt_collar();
        body();
    }
    face_cup();
    wire_hole();
    chin_flat_cut();
}
