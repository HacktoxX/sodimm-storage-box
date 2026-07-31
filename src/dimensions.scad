/*
 * Central derived dimensions.
 *
 * Coordinate convention:
 *   X: along the long edge of each SO-DIMM
 *   Y: across the storage rows
 *   Z: from the lowest stacking feature to the open top
 *
 * Feature modules consume these values instead of repeating calculations.
 * All dimensions are in millimetres unless stated otherwise.
 */

// A slot adds explicit manufacturing clearance to the nominal module envelope.
slot_length = sodimm_length + slot_length_clearance;
slot_width = sodimm_thickness + slot_thickness_clearance;

// The slot field contains every slot plus only the gaps between adjacent slots.
slot_area_length =
    (slots_per_row * slot_length) +
    ((slots_per_row - 1) * center_gap);
slot_area_width =
    (row_count * slot_width) +
    ((row_count - 1) * row_spacing);

// The main body surrounds the slot field with functional margin and a wall.
body_length = slot_area_length + (2 * (outer_margin_x + wall_thickness));
body_width = slot_area_width + (2 * (outer_margin_y + wall_thickness));
body_height = bottom_thickness + insertion_depth;

/*
 * The future male stacking ridge is kept inside the body footprint and inset
 * by its fit clearance. Its complete downward projection is nevertheless part
 * of the overall Z envelope used for printer-volume validation.
 */
stacking_outer_length = body_length - (2 * stacking_clearance);
stacking_outer_width = body_width - (2 * stacking_clearance);
stacking_inner_length =
    stacking_outer_length - (2 * stacking_feature_width);
stacking_inner_width =
    stacking_outer_width - (2 * stacking_feature_width);

// Overall printable envelope, including the downward stacking projection.
box_length = max(body_length, stacking_outer_length);
box_width = max(body_width, stacking_outer_width);
box_height = body_height + stacking_feature_height;

// Capacity is derived once so every subsystem reports the same value.
total_slot_count = slots_per_row * row_count;

// Slot-field origin measured from the lower outer corner of the body.
slot_start_x = wall_thickness + outer_margin_x;
slot_start_y = wall_thickness + outer_margin_y;

// Z positions account for the future feature below the main body.
body_start_z = stacking_feature_height;
slot_start_z = body_start_z + bottom_thickness;

// Diagnostic values are derived here to avoid repeated arithmetic in echo().
exposed_sodimm_height = sodimm_height - insertion_depth;
wall_line_count = wall_thickness / nozzle_diameter;
bottom_layer_count = bottom_thickness / layer_height;
