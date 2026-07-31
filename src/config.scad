/*
 * User-facing project configuration.
 *
 * Keep nominal hardware dimensions separate from manufacturing clearances.
 * Derived values belong in dimensions.scad, not in feature modules.
 */

// SO-DIMM nominal envelope, in millimetres.
so_dimm_length = 67.6;
so_dimm_height = 30.0;
so_dimm_thickness = 4.0;

// Storage layout.
slot_columns = 2;
slot_rows = 10;

// Target manufacturing process.
nozzle_diameter = 0.4;
layer_height = 0.20;
maximum_overhang_angle = 45;
printer_build_x = 256;
printer_build_y = 256;
printer_build_z = 256;

// Initial stacking coupon range; final value requires physical validation.
stack_clearance = 0.275;

// Adaptive label settings.
label_text = "PC4-3200";
label_style = "engraved"; // Supported values: "engraved" or "raised".
