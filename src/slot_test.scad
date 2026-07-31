/*
 * Compact calibration body for validating four real SO-DIMM slots.
 *
 * This file deliberately contains no production shell, stacking interface, or
 * final grip geometry. It reuses the central dimensions and slot cutouts.
 */

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

module slot_test_body(
    rows,
    columns,
    thickness_clearance
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
    if (debug_mode) {
        slot_test_configuration(slot_thickness_clearance);
    }

    slot_test_body(
        rows = slot_test_rows,
        columns = slot_test_columns,
        thickness_clearance = slot_thickness_clearance
    );
}
