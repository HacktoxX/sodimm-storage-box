/*
 * Milestone-only diagnostic output and envelope preview.
 *
 * This is intentionally not production geometry. The solid cuboid validates
 * the complete printer envelope; transparent background objects show where the
 * future slot generators will be placed without becoming part of an STL.
 */

debug_body_color = [0.20, 0.55, 0.85, 0.30];
debug_slot_color = [0.95, 0.45, 0.15, 0.65];

module debug_configuration() {
    echo("SO-DIMM storage box configuration");
    echo(str("Slots: ", total_slot_count));
    echo(str("Layout: ", slots_per_row, " x ", row_count));
    echo(str(
        "Slot dimensions: ",
        slot_length,
        " x ",
        slot_width,
        " mm"
    ));
    echo(str(
        "Box dimensions: ",
        box_length,
        " x ",
        box_width,
        " x ",
        box_height,
        " mm"
    ));
    echo(str("Insertion depth: ", insertion_depth, " mm"));
    echo(str(
        "Exposed SO-DIMM height: ",
        exposed_sodimm_height,
        " mm"
    ));
    echo(str(
        "Wall thickness: ",
        wall_thickness,
        " mm / ",
        wall_line_count,
        " nozzle lines"
    ));
    echo(str(
        "Bottom thickness: ",
        bottom_thickness,
        " mm / ",
        bottom_layer_count,
        " layers"
    ));
    echo(str("Stacking clearance: ", stacking_clearance, " mm"));
    echo(str(
        "Configured build volume: ",
        printer_build_x,
        " x ",
        printer_build_y,
        " x ",
        printer_build_z,
        " mm"
    ));
    echo(str(
        "P1S / configured build volume: ",
        build_volume_ok ? "OK" : "EXCEEDED"
    ));
}

module debug_slot_placeholders() {
    for (row_index = [0 : row_count - 1]) {
        for (column_index = [0 : slots_per_row - 1]) {
            translate([
                slot_start_x +
                    (column_index * (slot_length + center_gap)),
                slot_start_y +
                    (row_index * (slot_width + row_spacing)),
                slot_start_z
            ])
                cube([slot_length, slot_width, insertion_depth]);
        }
    }
}

module debug_preview() {
    color(debug_body_color)
        cube([box_length, box_width, box_height]);

    // Background geometry stays visible in preview but is excluded from export.
    %color(debug_slot_color)
        debug_slot_placeholders();
}
