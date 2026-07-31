/*
 * User-facing project configuration.
 *
 * Every value in this file is intended to be safe and useful to customize.
 * Calculations, assertions, and geometry belong in their dedicated source
 * files.
 *
 * All dimensions are in millimetres unless stated otherwise.
 */

// Nominal SO-DIMM assembly envelope.
sodimm_length = 67.6;
sodimm_height = 30.0;
sodimm_thickness = 4.2;

// Slot fit clearances.
slot_length_clearance = 1.2;
slot_thickness_clearance = 1.0;

// Support-free slot entry and contact-edge protection.
slot_chamfer_height = 1.2;
slot_chamfer_expansion = 0.8;
slot_contact_support_length = 5.0;
slot_contact_relief_depth = 0.8;

// Storage capacity and layout.
slots_per_row = 2;
row_count = 10;

// Spacing between slots and slot groups.
center_gap = 8.0;
row_spacing = 3.2;

// Main enclosure dimensions.
wall_thickness = 3.2;
bottom_thickness = 2.4;
outer_margin_x = 5.0;
outer_margin_y = 5.0;
corner_radius = 4.0;

// Vertical SO-DIMM engagement.
insertion_depth = 29.0;

// Self-centering stacking interface.
stacking_clearance = 0.25;
stacking_feature_height = 1.6;
stacking_feature_width = 2.4;
stacking_chamfer_angle = 45;

// Adaptive label.
label_text = "PC4-3200";
label_mode = "engraved"; // "engraved", "raised", or "disabled".
label_width = 58;
label_height = 11;
label_depth = 0.6;
label_max_font_size = 6.0;
label_min_font_size = 3.0;

// Target printer and process.
printer_build_x = 256;
printer_build_y = 256;
printer_build_z = 256;
nozzle_diameter = 0.4;
layer_height = 0.2;

// Four-slot calibration body.
slot_test_rows = 2;
slot_test_columns = 2;
slot_test_outer_margin = 3.2;
slot_test_grip_depth = 8.0;
slot_test_variant_mode = false;
slot_test_clearance_variants = [0.8, 1.0, 1.2];
slot_test_variant_spacing = 12.0;

// Render selection and diagnostic output.
render_mode = "slot_test"; // "debug" or "slot_test".
debug_mode = true;
