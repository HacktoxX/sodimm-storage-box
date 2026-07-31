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

// Validate primitive inputs before any derived value divides by them.
assert(
    sodimm_length > 0 && sodimm_height > 0 && sodimm_thickness > 0,
    "All nominal SO-DIMM dimensions must be positive."
);
assert(
    slots_per_row >= 1 && slots_per_row == floor(slots_per_row),
    "slots_per_row must be a whole number of at least 1."
);
assert(
    row_count >= 1 && row_count == floor(row_count),
    "row_count must be a whole number of at least 1."
);
assert(
    nozzle_diameter > 0,
    "nozzle_diameter must be positive."
);
assert(
    layer_height > 0,
    "layer_height must be positive."
);
assert(
    wall_thickness >= (2 * nozzle_diameter),
    "wall_thickness must be at least two nozzle diameters."
);
assert(
    bottom_thickness >= (3 * layer_height),
    "bottom_thickness must be at least three print layers."
);
assert(
    slot_length_clearance >= 0,
    "slot_length_clearance cannot be negative."
);
assert(
    slot_thickness_clearance >= 0,
    "slot_thickness_clearance cannot be negative."
);
assert(
    center_gap >= 0 && row_spacing >= 0,
    "Slot spacing values cannot be negative."
);
assert(
    outer_margin_x >= 0 && outer_margin_y >= 0,
    "Outer margins cannot be negative."
);
assert(
    insertion_depth > 0 && insertion_depth <= sodimm_height,
    "insertion_depth must be positive and cannot exceed sodimm_height."
);
assert(
    stacking_clearance >= 0,
    "stacking_clearance cannot be negative."
);
assert(
    stacking_feature_height > 0 && stacking_feature_width > 0,
    "Stacking feature dimensions must be positive."
);
assert(
    stacking_chamfer_angle > 0 && stacking_chamfer_angle <= 45,
    "Stacking chamfers above 45 degrees are not guaranteed to print support-free."
);
assert(
    corner_radius >= wall_thickness,
    "corner_radius must be at least wall_thickness for a valid inner radius."
);
assert(
    label_mode == "engraved" ||
    label_mode == "raised" ||
    label_mode == "disabled",
    "label_mode must be \"engraved\", \"raised\", or \"disabled\"."
);
assert(
    label_width > 0 && label_height > 0 && label_depth > 0,
    "Label dimensions must be positive."
);
assert(
    label_depth <= wall_thickness,
    "label_depth cannot exceed wall_thickness."
);
assert(
    label_min_font_size > 0 &&
    label_min_font_size <= label_max_font_size,
    "label_min_font_size must be positive and no larger than label_max_font_size."
);
assert(
    printer_build_x > 0 && printer_build_y > 0 && printer_build_z > 0,
    "Printer build-volume dimensions must be positive."
);

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

// Validate the complete chain of derived internal and external dimensions.
assert(
    slot_length > 0 && slot_width > 0,
    "Derived slot dimensions must be positive."
);
assert(
    slot_area_length > 0 && slot_area_width > 0,
    "Derived slot-area dimensions must be positive."
);
assert(
    body_length > 0 && body_width > 0 && body_height > 0,
    "Derived body dimensions must be positive."
);
assert(
    stacking_outer_length > 0 && stacking_outer_width > 0,
    "Derived stacking outer dimensions must be positive."
);
assert(
    stacking_inner_length > 0 && stacking_inner_width > 0,
    "stacking_feature_width is too large for the stacking interface."
);
assert(
    box_length > 0 && box_width > 0 && box_height > 0,
    "Derived overall box dimensions must be positive."
);
assert(
    corner_radius <= (min(body_length, body_width) / 2),
    "corner_radius cannot exceed half of the shortest body dimension."
);
assert(
    exposed_sodimm_height >= 0,
    "Derived exposed SO-DIMM height cannot be negative."
);
