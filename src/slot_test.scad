/*
 * Compact calibration body for validating four real SO-DIMM slots.
 *
 * This file deliberately contains no production shell, stacking interface, or
 * final grip geometry. It reuses the central dimensions and slot cutouts.
 */

slot_test_label_decimal_scale = 10;

function slot_test_clearance_label(clearance) =
    str(
        floor(clearance),
        ".",
        round(
            (clearance - floor(clearance)) *
            slot_test_label_decimal_scale
        )
    );

function slot_test_digit_segments(digit) =
    digit == "0" ? [true, true, true, true, true, true, false] :
    digit == "1" ? [false, true, true, false, false, false, false] :
    digit == "2" ? [true, true, false, true, true, false, true] :
    digit == "3" ? [true, true, true, true, false, false, true] :
    digit == "4" ? [false, true, true, false, false, true, true] :
    digit == "5" ? [true, false, true, true, false, true, true] :
    digit == "6" ? [true, false, true, true, true, true, true] :
    digit == "7" ? [true, true, true, false, false, false, false] :
    digit == "8" ? [true, true, true, true, true, true, true] :
    digit == "9" ? [true, true, true, true, false, true, true] :
    [false, false, false, false, false, false, false];

module slot_test_seven_segment_digit(
    digit,
    digit_height,
    stroke_width
) {
    digit_width = digit_height / 2;
    horizontal_length = digit_width - stroke_width;
    vertical_length = (digit_height - (3 * stroke_width)) / 2;
    middle_y = (digit_height - stroke_width) / 2;
    upper_vertical_y = middle_y + stroke_width;
    lower_vertical_y = stroke_width;
    right_x = digit_width - stroke_width;
    segments = slot_test_digit_segments(digit);

    assert(
        horizontal_length > 0 && vertical_length > 0,
        "Slot-test numeric mark is too small for the configured nozzle."
    );

    // Segment order: top, upper-right, lower-right, bottom,
    // lower-left, upper-left, middle.
    if (segments[0]) {
        translate([stroke_width / 2, digit_height - stroke_width])
            square([horizontal_length, stroke_width]);
    }
    if (segments[1]) {
        translate([right_x, upper_vertical_y])
            square([stroke_width, vertical_length]);
    }
    if (segments[2]) {
        translate([right_x, lower_vertical_y])
            square([stroke_width, vertical_length]);
    }
    if (segments[3]) {
        translate([stroke_width / 2, 0])
            square([horizontal_length, stroke_width]);
    }
    if (segments[4]) {
        translate([0, lower_vertical_y])
            square([stroke_width, vertical_length]);
    }
    if (segments[5]) {
        translate([0, upper_vertical_y])
            square([stroke_width, vertical_length]);
    }
    if (segments[6]) {
        translate([stroke_width / 2, middle_y])
            square([horizontal_length, stroke_width]);
    }
}

module slot_test_numeric_mark(
    mark_text,
    character_height,
    stroke_width
) {
    character_width = character_height / 2;
    character_pitch = character_width + stroke_width;
    mark_width =
        (len(mark_text) * character_pitch) - stroke_width;

    translate([-mark_width / 2, -character_height / 2]) {
        for (character_index = [0 : len(mark_text) - 1]) {
            character = mark_text[character_index];

            translate([character_index * character_pitch, 0]) {
                if (character == ".") {
                    translate([
                        (character_width - stroke_width) / 2,
                        0
                    ])
                        square([stroke_width, stroke_width]);
                } else {
                    slot_test_seven_segment_digit(
                        digit = character,
                        digit_height = character_height,
                        stroke_width = stroke_width
                    );
                }
            }
        }
    }
}

module slot_test_grip_clearance(
    body_length,
    body_width,
    body_height,
    grip_depth,
    bottom_width,
    top_width,
    boolean_overlap
) {
    assert(
        grip_depth > 0 && grip_depth < body_height,
        "Grip clearance depth must be positive and smaller than body height."
    );
    assert(
        top_width >= bottom_width && bottom_width > 0,
        "Grip clearance widths must be positive and expand toward the top."
    );

    translate([
        body_length / 2,
        -boolean_overlap,
        body_height + boolean_overlap
    ])
        rotate([-90, 0, 0])
            linear_extrude(
                height = body_width + (2 * boolean_overlap)
            )
                polygon(points = [
                    [-top_width / 2, 0],
                    [top_width / 2, 0],
                    [
                        bottom_width / 2,
                        grip_depth + boolean_overlap
                    ],
                    [
                        -bottom_width / 2,
                        grip_depth + boolean_overlap
                    ]
                ]);
}

module slot_test_identification_mark(
    body_height,
    mark_text
) {
    mark_depth = 2 * layer_height;
    mark_size = wall_thickness + (2 * layer_height);
    mark_stroke_width = nozzle_diameter;
    mark_center_x =
        slot_test_edge_width + (slot_test_slot_length / 2);
    mark_center_z = body_height / 2;

    assert(
        mark_depth > 0 && mark_depth < body_height,
        "Slot-test identification depth is invalid."
    );
    assert(
        mark_size > 0,
        "The outer wall is too narrow for a slot-test identification mark."
    );

    translate([
        mark_center_x,
        mark_depth,
        mark_center_z
    ])
        rotate([90, 0, 0])
            linear_extrude(
                height = mark_depth + slot_test_boolean_overlap
            )
                slot_test_numeric_mark(
                    mark_text = mark_text,
                    character_height = mark_size,
                    stroke_width = mark_stroke_width
                );
}

module slot_test_body(
    rows,
    columns,
    thickness_clearance,
    identification_text = ""
) {
    test_slot_width =
        slot_width_with_clearance(thickness_clearance);
    test_body_length = slot_test_body_length_for(columns);
    test_body_width =
        slot_test_body_width_for(thickness_clearance, rows);

    assert(
        rows >= 1 && columns >= 1,
        "Slot-test body rows and columns must be positive."
    );
    assert(
        test_slot_width > 0,
        "Slot-test body requires a positive slot width."
    );

    difference() {
        cube([
            test_body_length,
            test_body_width,
            slot_test_body_height
        ]);

        for (row_index = [0 : rows - 1]) {
            for (column_index = [0 : columns - 1]) {
                slot_center_x =
                    slot_test_edge_width +
                    (slot_test_slot_length / 2) +
                    (
                        column_index *
                        (slot_test_slot_length + center_gap)
                    );
                slot_center_y =
                    slot_test_edge_width +
                    (test_slot_width / 2) +
                    (
                        row_index *
                        (test_slot_width + row_spacing)
                    );

                translate([
                    slot_center_x,
                    slot_center_y,
                    bottom_thickness
                ]) {
                    sodimm_slot_cutout(
                        length = slot_test_slot_length,
                        width = test_slot_width,
                        depth = insertion_depth,
                        chamfer_height = slot_chamfer_height,
                        chamfer_expansion = slot_chamfer_expansion,
                        boolean_overlap = slot_test_boolean_overlap
                    );

                    sodimm_contact_relief_cutout(
                        length = slot_test_slot_length,
                        width = test_slot_width,
                        support_length = slot_contact_support_length,
                        relief_depth = slot_contact_relief_depth,
                        boolean_overlap = slot_test_boolean_overlap
                    );
                }
            }
        }

        slot_test_grip_clearance(
            body_length = test_body_length,
            body_width = test_body_width,
            body_height = slot_test_body_height,
            grip_depth = slot_test_grip_depth,
            bottom_width = slot_test_grip_bottom_width,
            top_width = slot_test_grip_top_width,
            boolean_overlap = slot_test_boolean_overlap
        );

        if (identification_text != "") {
            slot_test_identification_mark(
                body_height = slot_test_body_height,
                mark_text = identification_text
            );
        }
    }
}

module slot_test_configuration(thickness_clearance) {
    test_slot_width =
        slot_width_with_clearance(thickness_clearance);
    test_body_width =
        slot_test_body_width_for(thickness_clearance, slot_test_rows);

    echo("SO-DIMM slot test");
    echo(str(
        "Layout: ",
        slot_test_columns,
        " x ",
        slot_test_rows
    ));
    echo(str("Slot length: ", slot_test_slot_length, " mm"));
    echo(str("Slot width: ", test_slot_width, " mm"));
    echo(str("Insertion depth: ", insertion_depth, " mm"));
    echo(str("Chamfer height: ", slot_chamfer_height, " mm"));
    echo(str(
        "Chamfer expansion: ",
        slot_chamfer_expansion,
        " mm"
    ));
    echo(str(
        "Test body dimensions: ",
        slot_test_body_length,
        " x ",
        test_body_width,
        " x ",
        slot_test_body_height,
        " mm"
    ));
    echo(str(
        "Thickness clearance: ",
        thickness_clearance,
        " mm"
    ));
    echo(str(
        "Estimated module protrusion: ",
        exposed_sodimm_height,
        " mm"
    ));
}

module slot_test() {
    if (slot_test_variant_mode) {
        for (
            variant_index =
                [0 : slot_test_variant_count - 1]
        ) {
            variant_clearance =
                slot_test_clearance_variants[variant_index];

            if (debug_mode) {
                echo(str(
                    "Variant ",
                    variant_index + 1,
                    " of ",
                    slot_test_variant_count
                ));
                slot_test_configuration(variant_clearance);
            }

            translate([
                0,
                variant_index * slot_test_variant_pitch,
                0
            ])
                slot_test_body(
                    rows = slot_test_rows,
                    columns = slot_test_columns,
                    thickness_clearance = variant_clearance,
                    identification_text =
                        slot_test_clearance_label(
                            variant_clearance
                        )
                );
        }
    } else {
        if (debug_mode) {
            slot_test_configuration(slot_thickness_clearance);
        }

        slot_test_body(
            rows = slot_test_rows,
            columns = slot_test_columns,
            thickness_clearance = slot_thickness_clearance
        );
    }
}
