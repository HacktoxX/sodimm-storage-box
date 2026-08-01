/*
 * Kompakte Kalibrierkörper der Stapelschnittstelle.
 *
 * Unter- und Oberteil verwenden direkt die Merkmalsmodule aus stacking.scad.
 * Diese Datei enthält bewusst keine Geometrie des vollständigen Grundkörpers.
 */

function stacking_clearance_label(clearance) =
    let(
        scaled_value = round(clearance * 100),
        whole_value = floor(scaled_value / 100),
        decimal_value = scaled_value - (whole_value * 100),
        tenths_digit = floor(decimal_value / 10),
        hundredths_digit = decimal_value - (tenths_digit * 10)
    )
        str(
            whole_value,
            ".",
            tenths_digit,
            hundredths_digit
        );

module stacking_test_identification_cutout(
    plate_height,
    mark_text
) {
    assert(
        stacking_test_mark_depth > 0 &&
        stacking_test_mark_depth < plate_height,
        "Die Gravurtiefe des Stapeltests ist ungültig."
    );

    translate([
        stacking_test_body_length / 2,
        stacking_test_body_width / 2,
        plate_height - stacking_test_mark_depth
    ])
        linear_extrude(
            height = stacking_test_mark_depth + modeling_overlap
        )
            seven_segment_numeric_mark_2d(
                mark_text = mark_text,
                character_height = stacking_test_mark_height,
                stroke_width = nozzle_diameter
            );
}

module stacking_test_plate(height) {
    rounded_prism(
        length = stacking_test_body_length,
        width = stacking_test_body_width,
        height = height,
        radius = stacking_test_corner_radius,
        resolution = curve_resolution
    );
}

module stacking_test_bottom(clearance) {
    mark_text = stacking_clearance_label(clearance);

    difference() {
        union() {
            stacking_test_plate(stacking_test_bottom_thickness);

            translate([
                stacking_test_body_length / 2,
                stacking_test_body_width / 2,
                stacking_test_bottom_thickness - modeling_overlap
            ])
                stacking_male_feature(
                    frame_length = stacking_test_frame_length,
                    frame_width = stacking_test_frame_width,
                    feature_height =
                        stacking_feature_height + modeling_overlap,
                    feature_top_width = stacking_feature_top_width,
                    chamfer_angle = stacking_chamfer_angle
                );

            translate([
                stacking_test_body_length / 2,
                stacking_test_body_width / 2,
                stacking_test_bottom_thickness
            ])
                stacking_seating_lands(
                    length = stacking_support_land_length,
                    width = stacking_support_land_width,
                    offset_x = stacking_support_land_offset_x,
                    offset_y = stacking_support_land_offset_y,
                    height = stacking_standoff,
                    radius = nozzle_diameter,
                    boolean_overlap = modeling_overlap
                );
        }

        stacking_test_identification_cutout(
            plate_height = stacking_test_bottom_thickness,
            mark_text = mark_text
        );
    }
}

module stacking_test_top(clearance) {
    mark_text = stacking_clearance_label(clearance);

    difference() {
        stacking_test_plate(stacking_test_top_thickness);

        translate([
            stacking_test_body_length / 2,
            stacking_test_body_width / 2,
            0
        ])
            stacking_female_feature(
                frame_length = stacking_test_frame_length,
                frame_width = stacking_test_frame_width,
                feature_height = stacking_feature_height,
                feature_top_width = stacking_feature_top_width,
                chamfer_angle = stacking_chamfer_angle,
                standoff = stacking_standoff,
                clearance = clearance,
                boolean_overlap = modeling_overlap
            );

        stacking_test_identification_cutout(
            plate_height = stacking_test_top_thickness,
            mark_text = mark_text
        );
    }
}

/*
 * Druckanordnung aus Unter- und Oberteil. Beide Teile liegen bereits mit der
 * vorgesehenen supportfreien Fläche auf dem Druckbett.
 */
module stacking_test_pair(clearance) {
    assert(
        clearance >= 0,
        "Das Gesamtspiel des Stapeltestpaars darf nicht negativ sein."
    );

    stacking_test_bottom(clearance);

    translate([
        0,
        stacking_test_body_width + stacking_test_part_spacing,
        0
    ])
        stacking_test_top(clearance);
}

module stacking_test_configuration(clearance, variant_index = 0) {
    local_female_opening =
        stacking_female_opening_width_for(
            clearance,
            stacking_feature_height,
            stacking_feature_top_width,
            stacking_chamfer_angle,
            stacking_standoff
        );
    local_female_depth =
        stacking_female_depth_for(
            clearance,
            stacking_feature_height,
            stacking_feature_top_width,
            stacking_chamfer_angle,
            stacking_standoff
        );
    local_backing = stacking_test_top_thickness - local_female_depth;
    local_capture =
        (local_female_opening - stacking_feature_top_width) / 2;

    echo("SO-DIMM-Stapeltest");
    if (variant_index > 0) {
        echo(str("Variante: ", variant_index));
    }
    echo(str("Gesamtspiel: ", clearance, " mm"));
    echo(str("Spiel je Seite: ", clearance / 2, " mm"));
    echo(str("Flankenwinkel: ", stacking_chamfer_angle, " Grad"));
    echo(str("Federhöhe: ", stacking_feature_height, " mm"));
    echo(str("Federbasis: ", stacking_male_base_width, " mm"));
    echo(str("Federkrone: ", stacking_feature_top_width, " mm"));
    echo(str("Führungstiefe: ", stacking_engagement_depth, " mm"));
    echo(str("Zentrierweg je Achse: ", local_capture, " mm"));
    echo(str("Definierte Stapelhöhe: ", stacking_standoff, " mm"));
    echo(str(
        "Vertikaler Modulfreiraum: ",
        stacking_standoff - exposed_sodimm_height,
        " mm"
    ));
    echo(str("Nutöffnung: ", local_female_opening, " mm"));
    echo(str("Nuttiefe: ", local_female_depth, " mm"));
    echo(str("Verbleibende Nut-Rückwand: ", local_backing, " mm"));
    echo(str(
        "Horizontale Auflagefläche: ",
        stacking_support_land_area,
        " mm^2"
    ));
    echo(str(
        "Außenkantenabstand: ",
        stacking_test_edge_distance_x,
        " x ",
        stacking_test_edge_distance_y,
        " mm"
    ));
    echo(str(
        "Testpaar-Bounding-Box: ",
        stacking_test_pair_length,
        " x ",
        stacking_test_pair_width,
        " x ",
        stacking_test_pair_height,
        " mm"
    ));
    echo(str(
        "P1S / konfigurierter Bauraum: ",
        stacking_test_build_volume_ok ? "OK" : "ÜBERSCHRITTEN"
    ));
}

module stacking_test() {
    if (debug_mode) {
        stacking_test_configuration(stacking_clearance);
    }

    stacking_test_pair(stacking_clearance);
}

module stacking_test_variants() {
    for (variant_index = [0 : stacking_test_variant_count - 1]) {
        variant_clearance = stacking_clearance_variants[variant_index];
        variant_column =
            variant_index % stacking_test_variant_columns;
        variant_row =
            floor(variant_index / stacking_test_variant_columns);

        if (debug_mode) {
            stacking_test_configuration(
                variant_clearance,
                variant_index + 1
            );
        }

        translate([
            variant_column *
                (
                    stacking_test_pair_length +
                    stacking_test_variant_spacing
                ),
            variant_row *
                (
                    stacking_test_pair_width +
                    stacking_test_variant_spacing
                ),
            0
        ])
            stacking_test_pair(variant_clearance);
    }
}
