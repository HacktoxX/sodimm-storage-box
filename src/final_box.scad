/*
 * Produktionsreife offene SO-DIMM-Aufbewahrungsbox.
 *
 * Diese Merkmalsfamilie kombiniert ausschließlich bereits kalibrierte Slots,
 * den Grundkörper aus Meilenstein 3 und die physisch validierte Stapelkontur
 * aus Meilenstein 4. Deckel, Clips, Magnete und Zubehör sind bewusst nicht
 * Bestandteil der Geometrie.
 */

/*
 * Erzeugt genau eine vollständige, druckfertig orientierte Box.
 *
 * Die dachförmige Nut wird von der Druckbettseite subtrahiert. Ihre beiden
 * 45-Grad-Dachflächen können mit jeder neuen Schicht selbsttragend wachsen.
 * Feder und Auflagen überlappen den Grundkörper nur um modeling_overlap, um
 * koplanare Nullstärkenflächen zuverlässig zu vermeiden.
 */
module final_storage_box_body() {
    boolean_overlap = modeling_overlap;

    union() {
        difference() {
            rounded_prism(
                length = final_body_length,
                width = final_body_width,
                height = final_body_height,
                radius = corner_radius,
                resolution = curve_resolution
            );

            sodimm_slot_matrix_cutouts(
                rows = row_count,
                columns = slots_per_row,
                thickness_clearance = slot_thickness_clearance,
                boolean_overlap = boolean_overlap,
                local_slot_start_x = final_slot_start_x,
                local_slot_start_y = final_slot_start_y
            );

            support_free_grip_clearance(
                body_length = final_body_length,
                body_width = final_body_width,
                body_height = final_body_height,
                grip_depth = access_grip_depth,
                bottom_width = access_grip_bottom_width,
                top_width = access_grip_top_width,
                boolean_overlap = boolean_overlap,
                clearance_start_y = final_grip_start_y,
                clearance_width = final_grip_width
            );

            if (body_material_reliefs) {
                storage_body_perimeter_reliefs(
                    rows = row_count,
                    columns = slots_per_row,
                    thickness_clearance = slot_thickness_clearance,
                    local_body_length = final_body_length,
                    local_body_width = final_body_width,
                    boolean_overlap = boolean_overlap,
                    local_slot_start_x = final_slot_start_x,
                    local_slot_start_y = final_slot_start_y,
                    relief_depth_x = final_body_relief_depth,
                    relief_depth_y = final_body_relief_depth,
                    relief_front = false
                );
            }

            translate([
                final_body_length / 2,
                final_body_width / 2,
                0
            ])
                stacking_female_feature(
                    frame_length = final_stack_frame_length,
                    frame_width = final_stack_frame_width,
                    feature_height = stacking_feature_height,
                    feature_top_width = stacking_feature_top_width,
                    chamfer_angle = stacking_chamfer_angle,
                    standoff = stacking_standoff,
                    clearance = stacking_clearance,
                    boolean_overlap = boolean_overlap
                );

            adaptive_label_negative_features(
                center_x = final_label_center_x,
                center_z = final_label_center_z,
                text_value = label_text,
                mode = label_mode,
                width = label_width,
                height = label_height,
                recess_depth = label_panel_recess_depth,
                text_depth = label_depth,
                bevel = label_panel_bevel,
                corner_radius = label_panel_corner_radius,
                font_size = final_label_font_size,
                font_name = label_font,
                boolean_overlap = boolean_overlap,
                resolution = curve_resolution
            );
        }

        translate([
            final_body_length / 2,
            final_body_width / 2,
            final_body_height - boolean_overlap
        ])
            stacking_male_feature(
                frame_length = final_stack_frame_length,
                frame_width = final_stack_frame_width,
                feature_height =
                    stacking_feature_height + boolean_overlap,
                feature_top_width = stacking_feature_top_width,
                chamfer_angle = stacking_chamfer_angle
            );

        translate([
            final_body_length / 2,
            final_body_width / 2,
            final_body_height
        ])
            stacking_seating_lands(
                length = stacking_support_land_length,
                width = stacking_support_land_width,
                offset_x = final_support_land_offset_x,
                offset_y = final_support_land_offset_y,
                height = stacking_standoff,
                radius = nozzle_diameter,
                boolean_overlap = boolean_overlap
            );

        adaptive_label_positive_features(
            center_x = final_label_center_x,
            center_z = final_label_center_z,
            text_value = label_text,
            mode = label_mode,
            recess_depth = label_panel_recess_depth,
            text_depth = label_depth,
            font_size = final_label_font_size,
            font_name = label_font,
            boolean_overlap = boolean_overlap,
            resolution = curve_resolution
        );
    }
}

module final_box_configuration() {
    echo("Finale SO-DIMM-Aufbewahrungsbox");
    echo(str("Slots: ", total_slot_count));
    echo(str("Anordnung: ", slots_per_row, " x ", row_count));
    echo(str("Slotlänge: ", slot_length, " mm"));
    echo(str("Slotbreite: ", slot_width, " mm"));
    echo(str("Dickenspiel: ", slot_thickness_clearance, " mm"));
    echo(str(
        "Slotfeld: ",
        slot_area_length,
        " x ",
        slot_area_width,
        " mm"
    ));
    echo(str("Reihenabstand: ", row_spacing, " mm"));
    echo(str("Mittelsteg: ", body_center_web_width, " mm"));
    echo(str("Außenwand: ", wall_thickness, " mm"));
    echo(str("Modulüberstand: ", exposed_sodimm_height, " mm"));
    echo(str("Beschriftung: ", label_text));
    echo(str("Beschriftungsmodus: ", label_mode));
    echo(str(
        "Beschriftungsfeld: ",
        label_width,
        " x ",
        label_height,
        " mm"
    ));
    echo(str("Adaptive Schriftgröße: ", final_label_font_size, " mm"));
    echo(str("Stapelspiel gesamt: ", stacking_clearance, " mm"));
    echo(str("Stapelspiel je Seite: ", stacking_clearance_per_side, " mm"));
    echo(str("Flankenwinkel: ", stacking_chamfer_angle, " Grad"));
    echo(str("Führungstiefe: ", stacking_engagement_depth, " mm"));
    echo(str("Stapelabstand: ", stacking_standoff, " mm"));
    echo(str(
        "Vertikaler Modulfreiraum: ",
        stacking_standoff - exposed_sodimm_height,
        " mm"
    ));
    echo(str(
        "Stapelrahmen: ",
        final_stack_frame_length,
        " x ",
        final_stack_frame_width,
        " mm"
    ));
    echo(str(
        "Abstand Feder zu Slotfase: ",
        final_male_to_slot_clearance_x,
        " x ",
        final_male_to_slot_clearance_y,
        " mm"
    ));
    echo(str(
        "Materialrelieftiefe: ",
        final_body_relief_depth,
        " mm"
    ));
    echo(str(
        "Grundkörper: ",
        final_body_length,
        " x ",
        final_body_width,
        " x ",
        final_body_height,
        " mm"
    ));
    echo(str(
        "Finale Bounding-Box: ",
        final_box_length,
        " x ",
        final_box_width,
        " x ",
        final_box_height,
        " mm"
    ));
    echo(str(
        "Zwei Boxen gestapelt: ",
        final_box_length,
        " x ",
        final_box_width,
        " x ",
        final_two_box_stack_height,
        " mm"
    ));
    echo(str(
        "P1S / konfigurierter Bauraum: ",
        final_box_build_volume_ok ? "OK" : "ÜBERSCHRITTEN"
    ));
}

module final_box() {
    if (debug_mode) {
        final_box_configuration();
    }

    final_storage_box_body();
}
