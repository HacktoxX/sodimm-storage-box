/*
 * Merkmalsfamilie der adaptiven Beschriftung.
 *
 * Zuständig für horizontale und vertikale Zentrierung, Skalierung auf die
 * verfügbare Fläche sowie gravierte oder erhabene Ausgabe.
 */

/*
 * Zentriertes gerundetes Feld in der lokalen XY-Ebene.
 */
module label_rounded_field_2d(
    width,
    height,
    radius,
    resolution
) {
    translate([-width / 2, -height / 2])
        rounded_rectangle_2d(
            length = width,
            width = height,
            radius = radius,
            resolution = resolution
        );
}

/*
 * Schriftkontur mit bereits berechneter, einheitlicher Schriftgröße.
 */
module adaptive_label_text_2d(
    text_value,
    font_size,
    font_name,
    resolution
) {
    text(
        text = text_value,
        size = font_size,
        font = font_name,
        halign = "center",
        valign = "center",
        spacing = 1,
        $fn = resolution
    );
}

/*
 * Supportfrei gefastes Negativvolumen des Beschriftungsfelds.
 *
 * Die lokale Extrusionsachse wird auf +Y der Box gedreht. An der sichtbaren
 * Vorderseite ist das Feld größer; über label_panel_bevel verjüngt es sich
 * mit höchstens 45 Grad auf die innere Feldfläche.
 */
module adaptive_label_panel_cutout(
    center_x,
    center_z,
    width,
    height,
    recess_depth,
    text_depth,
    bevel,
    corner_radius,
    mode,
    boolean_overlap,
    resolution
) {
    cut_depth =
        mode == "raised"
            ? recess_depth + text_depth
            : recess_depth;
    inner_width = width - (2 * bevel);
    inner_height = height - (2 * bevel);
    inner_radius = corner_radius - bevel;

    assert(
        mode == "engraved" || mode == "raised",
        "Der Beschriftungsmodus des Felds ist ungültig."
    );
    assert(
        inner_width > 0 && inner_height > 0 && inner_radius > 0,
        "Die Feldfase lässt keine positive innere Beschriftungsfläche übrig."
    );

    union() {
        // Sichere Boolean-Öffnung unmittelbar vor der Außenfläche.
        translate([center_x, 0, center_z])
            rotate([90, 0, 0])
                linear_extrude(height = boolean_overlap)
                    label_rounded_field_2d(
                        width = width,
                        height = height,
                        radius = corner_radius,
                        resolution = resolution
                    );

        // Gefaster Übergang von der sichtbaren Öffnung zur inneren Fläche.
        translate([center_x, bevel, center_z])
            rotate([90, 0, 0])
                linear_extrude(
                    height = bevel,
                    scale = [
                        width / inner_width,
                        height / inner_height
                    ]
                )
                    label_rounded_field_2d(
                        width = inner_width,
                        height = inner_height,
                        radius = inner_radius,
                        resolution = resolution
                    );

        // Im Reliefmodus schafft dieser Abschnitt Platz für den Textkörper.
        if (cut_depth > bevel) {
            translate([
                center_x,
                cut_depth + boolean_overlap,
                center_z
            ])
                rotate([90, 0, 0])
                    linear_extrude(
                        height =
                            cut_depth - bevel + boolean_overlap
                    )
                        label_rounded_field_2d(
                            width = inner_width,
                            height = inner_height,
                            radius = inner_radius,
                            resolution = resolution
                        );
        }
    }
}

/*
 * Sämtliche von der Frontwand abzuziehenden Labelmerkmale.
 */
module adaptive_label_negative_features(
    center_x,
    center_z,
    text_value,
    mode,
    width,
    height,
    recess_depth,
    text_depth,
    bevel,
    corner_radius,
    font_size,
    font_name,
    boolean_overlap,
    resolution
) {
    adaptive_label_panel_cutout(
        center_x = center_x,
        center_z = center_z,
        width = width,
        height = height,
        recess_depth = recess_depth,
        text_depth = text_depth,
        bevel = bevel,
        corner_radius = corner_radius,
        mode = mode,
        boolean_overlap = boolean_overlap,
        resolution = resolution
    );

    if (mode == "engraved") {
        translate([
            center_x,
            recess_depth + text_depth + boolean_overlap,
            center_z
        ])
            rotate([90, 0, 0])
                linear_extrude(
                    height = text_depth + (2 * boolean_overlap)
                )
                    adaptive_label_text_2d(
                        text_value = text_value,
                        font_size = font_size,
                        font_name = font_name,
                        resolution = resolution
                    );
    }
}

/*
 * Erhabener Text innerhalb des tieferen, geschützten Beschriftungsfelds.
 * Seine Vorderfläche endet auf der vertieften Fase und ragt nicht über die
 * Außenhülle der Box hinaus.
 */
module adaptive_label_positive_features(
    center_x,
    center_z,
    text_value,
    mode,
    recess_depth,
    text_depth,
    font_size,
    font_name,
    boolean_overlap,
    resolution
) {
    if (mode == "raised") {
        translate([
            center_x,
            recess_depth + text_depth + boolean_overlap,
            center_z
        ])
            rotate([90, 0, 0])
                linear_extrude(
                    height = text_depth + (2 * boolean_overlap)
                )
                    adaptive_label_text_2d(
                        text_value = text_value,
                        font_size = font_size,
                        font_name = font_name,
                        resolution = resolution
                    );
    }
}
