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

/*
 * The build-volume result uses the complete printable envelope. box_height
 * already includes the future feature below the main body; X and Y use the
 * larger of the body and stacking footprints.
 */
build_volume_ok =
    box_length <= printer_build_x &&
    box_width <= printer_build_y &&
    box_height <= printer_build_z;
build_volume_remaining_x = printer_build_x - box_length;
build_volume_remaining_y = printer_build_y - box_width;
build_volume_remaining_z = printer_build_z - box_height;

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

// Fail on the exact printer axis that cannot contain the complete box envelope.
assert(
    box_length <= printer_build_x,
    str(
        "Box length of ",
        box_length,
        " mm exceeds printer_build_x of ",
        printer_build_x,
        " mm."
    )
);
assert(
    box_width <= printer_build_y,
    str(
        "Box width of ",
        box_width,
        " mm exceeds printer_build_y of ",
        printer_build_y,
        " mm."
    )
);
assert(
    box_height <= printer_build_z,
    str(
        "Box height of ",
        box_height,
        " mm exceeds printer_build_z of ",
        printer_build_z,
        " mm."
    )
);

/*
 * Four-slot calibration body
 *
 * These functions keep the test variants parameter-driven. The production
 * slot dimensions remain the source of truth; only thickness clearance varies
 * between calibration bodies.
 */
function slot_width_with_clearance(thickness_clearance) =
    sodimm_thickness + thickness_clearance;

function slot_test_field_length_for(columns) =
    (columns * slot_length) + ((columns - 1) * center_gap);

function slot_test_field_width_for(thickness_clearance, rows) =
    (rows * slot_width_with_clearance(thickness_clearance)) +
    ((rows - 1) * row_spacing);

function slot_test_body_length_for(columns) =
    slot_test_field_length_for(columns) + (2 * slot_test_edge_width);

function slot_test_body_width_for(thickness_clearance, rows) =
    slot_test_field_width_for(thickness_clearance, rows) +
    (2 * slot_test_edge_width);

assert(
    render_mode == "debug" || render_mode == "slot_test",
    "render_mode must be \"debug\" or \"slot_test\"."
);
assert(
    slot_test_rows >= 1 && slot_test_rows == floor(slot_test_rows),
    "slot_test_rows must be a whole number of at least 1."
);
assert(
    slot_test_columns >= 1 &&
    slot_test_columns == floor(slot_test_columns),
    "slot_test_columns must be a whole number of at least 1."
);
assert(
    slot_chamfer_height > 0,
    "slot_chamfer_height must be positive."
);
assert(
    slot_chamfer_expansion >= 0,
    "slot_chamfer_expansion cannot be negative."
);
assert(
    slot_chamfer_expansion <= slot_chamfer_height,
    "slot_chamfer_expansion cannot exceed slot_chamfer_height; the entry surface would exceed 45 degrees."
);
assert(
    slot_chamfer_height < insertion_depth,
    "slot_chamfer_height must be smaller than insertion_depth."
);
assert(
    slot_contact_support_length > 0 &&
    (2 * slot_contact_support_length) < slot_length,
    "slot_contact_support_length must leave an open contact-relief region."
);
assert(
    slot_contact_relief_depth > 0,
    "slot_contact_relief_depth must be positive."
);
assert(
    (bottom_thickness - slot_contact_relief_depth) >= (3 * layer_height),
    "The floor below the contact relief must remain at least three layers thick."
);
assert(
    slot_test_outer_margin >= wall_thickness,
    "slot_test_outer_margin must preserve at least wall_thickness."
);
assert(
    slot_test_grip_depth > 0,
    "slot_test_grip_depth must be positive."
);
assert(
    slot_test_variant_mode == true || slot_test_variant_mode == false,
    "slot_test_variant_mode must be true or false."
);
assert(
    len(slot_test_clearance_variants) >= 1,
    "slot_test_clearance_variants must contain at least one value."
);
for (variant_clearance = slot_test_clearance_variants) {
    assert(
        variant_clearance >= 0,
        "Every slot-test thickness clearance must be non-negative."
    );
}
assert(
    slot_test_variant_spacing >= wall_thickness,
    "slot_test_variant_spacing must be at least wall_thickness."
);

// The test edge is never thinner than the production wall.
slot_test_edge_width = max(wall_thickness, slot_test_outer_margin);

// The test uses the production slot length, center gap, and row spacing.
slot_test_slot_length = slot_length;
slot_test_slot_width =
    slot_width_with_clearance(slot_thickness_clearance);
slot_test_field_length = slot_test_field_length_for(slot_test_columns);
slot_test_field_width =
    slot_test_field_width_for(slot_thickness_clearance, slot_test_rows);

slot_test_body_length = slot_test_body_length_for(slot_test_columns);
slot_test_body_width =
    slot_test_body_width_for(slot_thickness_clearance, slot_test_rows);
slot_test_body_height = bottom_thickness + insertion_depth;

// Slot placement starts after the compact outer wall.
slot_test_slot_start_x = slot_test_edge_width;
slot_test_slot_start_y = slot_test_edge_width;
slot_test_slot_start_z = bottom_thickness;

// The straight guide ends where the symmetric top chamfer begins.
slot_straight_guide_depth = insertion_depth - slot_chamfer_height;

/*
 * Two end rails remain at the nominal bottom level. The relief between them
 * protects the contact edge while retaining a printable closed floor.
 */
slot_contact_relief_length =
    slot_test_slot_length - (2 * slot_contact_support_length);
slot_contact_floor_thickness =
    bottom_thickness - slot_contact_relief_depth;

/*
 * The removal opening starts at the full center gap and expands one millimetre
 * horizontally per millimetre vertically. Its 45-degree faces are support-free.
 */
slot_test_grip_bottom_width = center_gap;
slot_test_grip_top_width =
    slot_test_grip_bottom_width + (2 * slot_test_grip_depth);
slot_test_remaining_center_web_height =
    slot_test_body_height - slot_test_grip_depth;

// Explicit web calculations prove that adjacent tapered slots do not collide.
slot_test_column_web_width = center_gap;
slot_test_row_web_width = row_spacing;
slot_test_chamfer_column_web_width =
    slot_test_column_web_width - (2 * slot_chamfer_expansion);
slot_test_chamfer_row_web_width =
    slot_test_row_web_width - (2 * slot_chamfer_expansion);
slot_test_chamfer_outer_wall =
    slot_test_edge_width - slot_chamfer_expansion;

// A modeling overlap derived from the layer height avoids coplanar booleans.
slot_test_boolean_overlap = layer_height / 10;

// Variant spacing uses the widest configured body, independent of array order.
slot_test_variant_count = len(slot_test_clearance_variants);
slot_test_max_variant_clearance =
    slot_test_variant_count > 0
        ? max(slot_test_clearance_variants)
        : slot_thickness_clearance;
slot_test_max_variant_body_width =
    slot_test_body_width_for(
        slot_test_max_variant_clearance,
        slot_test_rows
    );
slot_test_variant_pitch =
    slot_test_max_variant_body_width + slot_test_variant_spacing;
slot_test_variants_width =
    (slot_test_variant_count * slot_test_max_variant_body_width) +
    ((slot_test_variant_count - 1) * slot_test_variant_spacing);

// Overall render envelope switches between one body and the variant array.
slot_test_render_length = slot_test_body_length;
slot_test_render_width =
    slot_test_variant_mode
        ? slot_test_variants_width
        : slot_test_body_width;
slot_test_render_height = slot_test_body_height;
slot_test_build_volume_ok =
    slot_test_render_length <= printer_build_x &&
    slot_test_render_width <= printer_build_y &&
    slot_test_render_height <= printer_build_z;

assert(
    slot_test_slot_width > 0,
    "The derived slot-test width must be positive."
);
assert(
    slot_test_body_length > 0 &&
    slot_test_body_width > 0 &&
    slot_test_body_height > 0,
    "All derived slot-test body dimensions must be positive."
);
assert(
    slot_contact_relief_length > 0,
    "The contact support rails leave no central contact relief."
);
assert(
    slot_test_remaining_center_web_height >=
        (bottom_thickness + wall_thickness),
    "The grip clearance leaves less than wall_thickness above the bottom."
);
assert(
    slot_test_chamfer_column_web_width > 0,
    "Column chamfers collide across center_gap."
);
assert(
    slot_test_chamfer_row_web_width > 0,
    "Row chamfers collide across row_spacing."
);
assert(
    slot_test_chamfer_outer_wall >= (2 * nozzle_diameter),
    "The chamfer leaves less than two nozzle diameters at the outer wall."
);
assert(
    slot_test_render_length <= printer_build_x,
    "The slot-test render exceeds printer_build_x."
);
assert(
    slot_test_render_width <= printer_build_y,
    "The slot-test render exceeds printer_build_y."
);
assert(
    slot_test_render_height <= printer_build_z,
    "The slot-test render exceeds printer_build_z."
);
