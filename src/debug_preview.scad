/*
 * Meilensteinbezogene Diagnoseausgabe und Bauraumvorschau.
 *
 * Dies ist bewusst keine finale Geometrie. Der massive Quader prüft den
 * konservativ reservierten Druckbauraum; transparente Hintergrundobjekte
 * zeigen die Positionen der späteren Slots, ohne Bestandteil einer STL zu
 * werden.
 */

debug_body_color = [0.20, 0.55, 0.85, 0.30];
debug_slot_color = [0.95, 0.45, 0.15, 0.65];

module debug_configuration() {
    echo("Konfiguration der SO-DIMM-Aufbewahrungsbox");
    echo(str("Slots: ", total_slot_count));
    echo(str("Anordnung: ", slots_per_row, " x ", row_count));
    echo(str(
        "Slotabmessungen: ",
        slot_length,
        " x ",
        slot_width,
        " mm"
    ));
    echo(str(
        "Boxabmessungen: ",
        box_length,
        " x ",
        box_width,
        " x ",
        box_height,
        " mm"
    ));
    echo(str("Einstecktiefe: ", insertion_depth, " mm"));
    echo(str(
        "Freiliegende SO-DIMM-Höhe: ",
        exposed_sodimm_height,
        " mm"
    ));
    echo(str(
        "Wandstärke: ",
        wall_thickness,
        " mm / ",
        wall_line_count,
        " Düsenlinien"
    ));
    echo(str(
        "Bodenstärke: ",
        bottom_thickness,
        " mm / ",
        bottom_layer_count,
        " Schichten"
    ));
    echo(str("Stapel-Gesamtspiel: ", stacking_clearance, " mm"));
    echo(str(
        "Konfigurierter Bauraum: ",
        printer_build_x,
        " x ",
        printer_build_y,
        " x ",
        printer_build_z,
        " mm"
    ));
    echo(str(
        "P1S / konfigurierter Bauraum: ",
        build_volume_ok ? "OK" : "ÜBERSCHRITTEN"
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

    // Hintergrundgeometrie bleibt sichtbar, wird aber nicht exportiert.
    %color(debug_slot_color)
        debug_slot_placeholders();
}
