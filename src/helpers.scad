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
    boolean_overlap
) {
    grip_expansion_per_side = (top_width - bottom_width) / 2;

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
