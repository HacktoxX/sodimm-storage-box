/*
 * Merkmalsfamilie des Grundkörpers.
 *
 * Der Körper verwendet dieselben kalibrierten Slot- und Kontaktmodule wie der
 * Vier-Slot-Test. Vollkörper und Kurztest unterscheiden sich ausschließlich
 * durch die parametrierte Reihenzahl.
 */

/*
 * Ordnet die kalibrierten Negativvolumen als parametrische Slotmatrix an.
 */
module sodimm_slot_matrix_cutouts(
    rows,
    columns,
    thickness_clearance,
    boolean_overlap
) {
    matrix_slot_width =
        slot_width_with_clearance(thickness_clearance);

    assert(
        rows >= 1 && rows == floor(rows),
        "Die Reihenzahl der Slotmatrix muss eine ganze Zahl von mindestens 1 sein."
    );
    assert(
        columns >= 1 && columns == floor(columns),
        "Die Spaltenzahl der Slotmatrix muss eine ganze Zahl von mindestens 1 sein."
    );

    for (row_index = [0 : rows - 1]) {
        for (column_index = [0 : columns - 1]) {
            slot_center_x =
                slot_start_x +
                (slot_length / 2) +
                (
                    column_index *
                    (slot_length + center_gap)
                );
            slot_center_y =
                slot_start_y +
                (matrix_slot_width / 2) +
                (
                    row_index *
                    (matrix_slot_width + row_spacing)
                );

            translate([
                slot_center_x,
                slot_center_y,
                bottom_thickness
            ]) {
                sodimm_slot_cutout(
                    length = slot_length,
                    width = matrix_slot_width,
                    depth = insertion_depth,
                    chamfer_height = slot_chamfer_height,
                    chamfer_expansion = slot_chamfer_expansion,
                    boolean_overlap = boolean_overlap
                );

                sodimm_contact_relief_cutout(
                    length = slot_length,
                    width = matrix_slot_width,
                    support_length = slot_contact_support_length,
                    relief_depth = slot_contact_relief_depth,
                    boolean_overlap = boolean_overlap
                );
            }
        }
    }
}

/*
 * Erzeugt topoffene Reliefs in den überdimensionierten Randzonen.
 *
 * Die verbleibenden Außenwände, Reihenstege und der Mittelsteg bilden ein
 * umlaufend verbundenes Rippensystem. Alle Taschen sind nach oben und zur
 * jeweiligen Außenseite offen und besitzen daher keine horizontalen Decken.
 */
module storage_body_perimeter_reliefs(
    rows,
    columns,
    thickness_clearance,
    local_body_length,
    local_body_width,
    boolean_overlap
) {
    matrix_slot_width =
        slot_width_with_clearance(thickness_clearance);
    relief_radius = min(
        body_relief_corner_radius,
        body_relief_depth_x / 2,
        body_relief_depth_y / 2,
        matrix_slot_width / 2
    );
    relief_height = body_relief_height + boolean_overlap;

    for (row_index = [0 : rows - 1]) {
        relief_start_y =
            slot_start_y +
            (
                row_index *
                (matrix_slot_width + row_spacing)
            );

        translate([
            -boolean_overlap,
            relief_start_y,
            bottom_thickness
        ])
            rounded_prism(
                length = body_relief_depth_x + boolean_overlap,
                width = matrix_slot_width,
                height = relief_height,
                radius = relief_radius,
                resolution = curve_resolution
            );

        translate([
            local_body_length - body_relief_depth_x,
            relief_start_y,
            bottom_thickness
        ])
            rounded_prism(
                length = body_relief_depth_x + boolean_overlap,
                width = matrix_slot_width,
                height = relief_height,
                radius = relief_radius,
                resolution = curve_resolution
            );
    }

    for (column_index = [0 : columns - 1]) {
        relief_start_x =
            slot_start_x +
            (
                column_index *
                (slot_length + center_gap)
            );

        translate([
            relief_start_x,
            -boolean_overlap,
            bottom_thickness
        ])
            rounded_prism(
                length = slot_length,
                width = body_relief_depth_y + boolean_overlap,
                height = relief_height,
                radius = relief_radius,
                resolution = curve_resolution
            );

        translate([
            relief_start_x,
            local_body_width - body_relief_depth_y,
            bottom_thickness
        ])
            rounded_prism(
                length = slot_length,
                width = body_relief_depth_y + boolean_overlap,
                height = relief_height,
                radius = relief_radius,
                resolution = curve_resolution
            );
    }
}

/*
 * Gemeinsamer Grundkörper für vollständige und verkürzte Slotmatrix.
 */
module storage_box_body(
    rows,
    columns,
    thickness_clearance,
    material_reliefs = true
) {
    local_body_length = storage_body_length_for(columns);
    local_body_width =
        storage_body_width_for(rows, thickness_clearance);
    local_body_height = body_height;
    boolean_overlap = modeling_overlap;

    assert(
        material_reliefs == true || material_reliefs == false,
        "material_reliefs muss true oder false sein."
    );

    difference() {
        rounded_prism(
            length = local_body_length,
            width = local_body_width,
            height = local_body_height,
            radius = corner_radius,
            resolution = curve_resolution
        );

        sodimm_slot_matrix_cutouts(
            rows = rows,
            columns = columns,
            thickness_clearance = thickness_clearance,
            boolean_overlap = boolean_overlap
        );

        support_free_grip_clearance(
            body_length = local_body_length,
            body_width = local_body_width,
            body_height = local_body_height,
            grip_depth = access_grip_depth,
            bottom_width = access_grip_bottom_width,
            top_width = access_grip_top_width,
            boolean_overlap = boolean_overlap
        );

        if (material_reliefs) {
            storage_body_perimeter_reliefs(
                rows = rows,
                columns = columns,
                thickness_clearance = thickness_clearance,
                local_body_length = local_body_length,
                local_body_width = local_body_width,
                boolean_overlap = boolean_overlap
            );
        }
    }
}

module storage_box_configuration(rows, columns, thickness_clearance) {
    matrix_slot_width =
        slot_width_with_clearance(thickness_clearance);
    matrix_length = slot_matrix_length_for(columns);
    matrix_width = slot_matrix_width_for(rows, thickness_clearance);
    local_body_length = storage_body_length_for(columns);
    local_body_width =
        storage_body_width_for(rows, thickness_clearance);
    local_slot_count = rows * columns;
    local_build_volume_ok =
        local_body_length <= printer_build_x &&
        local_body_width <= printer_build_y &&
        body_height <= printer_build_z;

    echo("SO-DIMM-Grundkörper");
    echo(str("Slots: ", local_slot_count));
    echo(str("Anordnung: ", columns, " x ", rows));
    echo(str("Slotlänge: ", slot_length, " mm"));
    echo(str("Slotbreite: ", matrix_slot_width, " mm"));
    echo(str(
        "Dickenspiel: ",
        thickness_clearance,
        " mm"
    ));
    echo(str(
        "Slotfeld: ",
        matrix_length,
        " x ",
        matrix_width,
        " mm"
    ));
    echo(str("Reihenabstand: ", row_spacing, " mm"));
    echo(str("Mittelsteg: ", body_center_web_width, " mm"));
    echo(str("Außenwand: ", wall_thickness, " mm"));
    echo(str(
        "Kontaktboden: ",
        body_contact_floor_thickness,
        " mm"
    ));
    echo(str(
        "Tragende Höhe unter Entnahmezone: ",
        access_grip_remaining_web_height,
        " mm"
    ));
    echo(str(
        "Modulüberstand: ",
        exposed_sodimm_height,
        " mm"
    ));
    echo(str(
        "Grundkörper-Bounding-Box: ",
        local_body_length,
        " x ",
        local_body_width,
        " x ",
        body_height,
        " mm"
    ));
    echo(str(
        "P1S / konfigurierter Bauraum: ",
        local_build_volume_ok ? "OK" : "ÜBERSCHRITTEN"
    ));
}

module full_box() {
    if (debug_mode) {
        storage_box_configuration(
            rows = row_count,
            columns = slots_per_row,
            thickness_clearance = slot_thickness_clearance
        );
    }

    storage_box_body(
        rows = row_count,
        columns = slots_per_row,
        thickness_clearance = slot_thickness_clearance,
        material_reliefs = body_material_reliefs
    );
}

module full_box_short() {
    if (debug_mode) {
        storage_box_configuration(
            rows = full_box_short_rows,
            columns = slots_per_row,
            thickness_clearance = slot_thickness_clearance
        );
    }

    storage_box_body(
        rows = full_box_short_rows,
        columns = slots_per_row,
        thickness_clearance = slot_thickness_clearance,
        material_reliefs = body_material_reliefs
    );
}
