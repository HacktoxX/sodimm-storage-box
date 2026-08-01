/*
 * Wiederverwendbare Geometrie- und Prüfungshilfen.
 */

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
