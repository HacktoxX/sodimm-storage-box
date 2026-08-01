/*
 * Wiederverwendbare Geometrie- und Prüfungshilfen.
 */

/*
 * Erzeugt ein Rechteck mit konstantem Radius an allen vier Außenecken.
 */
module rounded_rectangle_2d(
    length,
    width,
    radius,
    resolution
) {
    assert(
        length > 0 && width > 0,
        "Die Abmessungen des gerundeten Rechtecks müssen positiv sein."
    );
    assert(
        radius > 0 && radius <= (min(length, width) / 2),
        "Der Radius des gerundeten Rechtecks ist ungültig."
    );
    assert(
        resolution >= 12 && resolution == floor(resolution),
        "Die Kurvenauflösung muss eine ganze Zahl von mindestens 12 sein."
    );

    hull() {
        for (x = [radius, length - radius]) {
            for (y = [radius, width - radius]) {
                translate([x, y])
                    circle(r = radius, $fn = resolution);
            }
        }
    }
}

/*
 * Extrudiert die gerundete Grundfläche ohne Überhänge in Z-Richtung.
 */
module rounded_prism(
    length,
    width,
    height,
    radius,
    resolution
) {
    assert(height > 0, "Die Höhe des gerundeten Prismas muss positiv sein.");

    linear_extrude(height = height)
        rounded_rectangle_2d(
            length = length,
            width = width,
            radius = radius,
            resolution = resolution
        );
}

/*
 * Erzeugt eine über die gesamte Körperbreite laufende Entnahmefreistellung.
 *
 * Der trapezförmige Querschnitt erweitert sich nach oben. Wenn die seitliche
 * Erweiterung höchstens der Tiefe entspricht, bleiben die Flächen bei maximal
 * 45 Grad und damit in der vorgesehenen Druckausrichtung supportfrei.
 */
module support_free_grip_clearance(
    body_length,
    body_width,
    body_height,
    grip_depth,
    bottom_width,
    top_width,
    boolean_overlap,
    clearance_start_y = 0,
    clearance_width = undef
) {
    grip_expansion_per_side = (top_width - bottom_width) / 2;
    local_clearance_width =
        is_undef(clearance_width) ? body_width : clearance_width;

    assert(
        grip_depth > 0 && grip_depth < body_height,
        "Die Tiefe der Entnahmefreistellung muss positiv und kleiner als die Körperhöhe sein."
    );
    assert(
        top_width >= bottom_width && bottom_width > 0,
        "Die Breiten der Entnahmefreistellung müssen positiv sein und sich nach oben erweitern."
    );
    assert(
        grip_expansion_per_side <= grip_depth,
        "Die Entnahmefreistellung wäre steiler als 45 Grad."
    );
    assert(
        boolean_overlap >= 0,
        "Die Boolean-Überlappung darf nicht negativ sein."
    );
    assert(
        clearance_start_y >= 0 && local_clearance_width > 0,
        "Position und Breite der Entnahmefreistellung müssen positiv sein."
    );
    assert(
        clearance_start_y + local_clearance_width <= body_width,
        "Die Entnahmefreistellung darf die Körperbreite nicht überschreiten."
    );

    translate([
        body_length / 2,
        clearance_start_y - boolean_overlap,
        body_height + boolean_overlap
    ])
        rotate([-90, 0, 0])
            linear_extrude(
                height = local_clearance_width + (2 * boolean_overlap)
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

/*
 * Schriftunabhängige Ziffern für einfache Kalibrierkennzeichnungen.
 *
 * Dieses bewusst kleine Siebensegment-System gehört nicht zum späteren
 * adaptiven Labelsystem. Slot- und Stapeltests können damit reproduzierbare
 * Zahlen gravieren, ohne von lokal installierten Schriftarten abzuhängen.
 */
function seven_segment_digit_segments(digit) =
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

module seven_segment_digit_2d(
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
    segments = seven_segment_digit_segments(digit);

    assert(
        horizontal_length > 0 && vertical_length > 0,
        "Die numerische Kennzeichnung ist für die konfigurierte Düse zu klein."
    );

    // Segmentreihenfolge: oben, rechts oben, rechts unten, unten,
    // links unten, links oben, Mitte.
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

module seven_segment_numeric_mark_2d(
    mark_text,
    character_height,
    stroke_width
) {
    character_width = character_height / 2;
    character_pitch = character_width + stroke_width;
    mark_width =
        (len(mark_text) * character_pitch) - stroke_width;

    assert(
        len(mark_text) >= 1,
        "Die numerische Kennzeichnung darf nicht leer sein."
    );

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
                    seven_segment_digit_2d(
                        digit = character,
                        digit_height = character_height,
                        stroke_width = stroke_width
                    );
                }
            }
        }
    }
}
