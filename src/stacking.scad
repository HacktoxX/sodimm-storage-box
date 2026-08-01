/*
 * Merkmalsfamilie der selbstzentrierenden Stapelmechanik.
 *
 * Zuständig für zueinander passende konische Schnittstellen, druckbare
 * 45-Grad-Flächen, Lösespiel und die Ausrichtung im Stapel.
 */

/*
 * Geschlossener trapezförmiger Schienenquerschnitt entlang der X-Achse.
 * Die Krone bleibt über ihre gesamte Länge flach und mechanisch robust.
 */
module stacking_trapezoid_rail(
    length,
    base_width,
    top_width,
    height
) {
    assert(
        length > 0 && base_width > 0 && top_width > 0 && height > 0,
        "Alle Maße der trapezförmigen Stapelschiene müssen positiv sein."
    );
    assert(
        base_width > top_width,
        "Die Basis der Stapelschiene muss breiter als ihre Krone sein."
    );

    polyhedron(
        points = [
            [-length / 2, -base_width / 2, 0],
            [length / 2, -base_width / 2, 0],
            [length / 2, base_width / 2, 0],
            [-length / 2, base_width / 2, 0],
            [-length / 2, -top_width / 2, height],
            [length / 2, -top_width / 2, height],
            [length / 2, top_width / 2, height],
            [-length / 2, top_width / 2, height]
        ],
        faces = [
            [0, 3, 2, 1],
            [4, 5, 6, 7],
            [0, 1, 5, 4],
            [1, 2, 6, 5],
            [2, 3, 7, 6],
            [3, 0, 4, 7]
        ],
        convexity = 4
    );
}

/*
 * Dreieckiger negativer Schienenquerschnitt entlang der X-Achse.
 *
 * Die Nut endet in einer Dachkante. Anders als ein rechteckiger Blindkanal
 * erzeugt sie damit keine nach unten gerichtete horizontale Decke.
 */
module stacking_roof_rail_cutout(
    length,
    opening_width,
    roof_depth
) {
    assert(
        length > 0 && opening_width > 0 && roof_depth > 0,
        "Alle Maße des dachförmigen Stapelnutausschnitts müssen positiv sein."
    );

    polyhedron(
        points = [
            [-length / 2, -opening_width / 2, 0],
            [length / 2, -opening_width / 2, 0],
            [length / 2, opening_width / 2, 0],
            [-length / 2, opening_width / 2, 0],
            [-length / 2, 0, roof_depth],
            [length / 2, 0, roof_depth]
        ],
        faces = [
            [0, 3, 2, 1],
            [0, 1, 5, 4],
            [3, 4, 5, 2],
            [0, 4, 3],
            [1, 2, 5]
        ],
        convexity = 4
    );
}

/*
 * Männlicher, in X und Y selbstzentrierender Führungsrahmen.
 *
 * Vier überlappende Schienen bilden eine segmentierbare Nut-/Feder-Kontur.
 * Alle Maße werden explizit übergeben, damit später derselbe Generator für
 * den Vollkörper verwendet werden kann.
 */
module stacking_male_feature(
    frame_length,
    frame_width,
    feature_height,
    feature_top_width,
    chamfer_angle
) {
    slope_run =
        feature_height *
        stacking_slope_run_per_height_for(chamfer_angle);
    base_width = feature_top_width + (2 * slope_run);

    assert(
        chamfer_angle > 0 && chamfer_angle <= 45,
        "Die Flanken der Stapelfeder überschreiten die supportfreie 45-Grad-Grenze."
    );
    assert(
        frame_length > base_width && frame_width > base_width,
        "Der männliche Stapelrahmen benötigt eine positive innere Öffnung."
    );

    union() {
        for (side_y = [-1, 1]) {
            translate([0, side_y * frame_width / 2, 0])
                stacking_trapezoid_rail(
                    length = frame_length + base_width,
                    base_width = base_width,
                    top_width = feature_top_width,
                    height = feature_height
                );
        }

        for (side_x = [-1, 1]) {
            translate([side_x * frame_length / 2, 0, 0])
                rotate([0, 0, 90])
                    stacking_trapezoid_rail(
                        length = frame_width + base_width,
                        base_width = base_width,
                        top_width = feature_top_width,
                        height = feature_height
                    );
        }
    }
}

/*
 * Weibliches Negativvolumen für denselben Führungsrahmen.
 *
 * clearance ist das horizontale Gesamtspiel zwischen zwei gegenüberliegenden
 * Flanken. Der Öffnungsquerschnitt erhält daher clearance/2 je Seite. Die
 * separate Auflagehöhe begrenzt die Eingriffstiefe, ohne die Flanken zu
 * verklemmen.
 */
module stacking_female_feature(
    frame_length,
    frame_width,
    feature_height,
    feature_top_width,
    chamfer_angle,
    standoff,
    clearance,
    boolean_overlap
) {
    slope_run_per_height =
        stacking_slope_run_per_height_for(chamfer_angle);
    nominal_opening_width =
        stacking_female_opening_width_for(
            clearance,
            feature_height,
            feature_top_width,
            chamfer_angle,
            standoff
        );
    nominal_roof_depth =
        stacking_female_depth_for(
            clearance,
            feature_height,
            feature_top_width,
            chamfer_angle,
            standoff
        );
    cutout_opening_width =
        nominal_opening_width +
        (2 * boolean_overlap * slope_run_per_height);
    cutout_roof_depth = nominal_roof_depth + boolean_overlap;

    assert(clearance >= 0, "Das Gesamtspiel der Stapelnut darf nicht negativ sein.");
    assert(
        standoff > 0 && standoff < feature_height,
        "Die Auflagehöhe muss positiv und kleiner als die Federhöhe sein."
    );
    assert(
        chamfer_angle > 0 && chamfer_angle <= 45,
        "Das Dach der Stapelnut überschreitet die supportfreie 45-Grad-Grenze."
    );
    assert(
        boolean_overlap >= 0,
        "Die Boolean-Überlappung der Stapelnut darf nicht negativ sein."
    );

    translate([0, 0, -boolean_overlap])
        union() {
            for (side_y = [-1, 1]) {
                translate([0, side_y * frame_width / 2, 0])
                    stacking_roof_rail_cutout(
                        length = frame_length + cutout_opening_width,
                        opening_width = cutout_opening_width,
                        roof_depth = cutout_roof_depth
                    );
            }

            for (side_x = [-1, 1]) {
                translate([side_x * frame_length / 2, 0, 0])
                    rotate([0, 0, 90])
                        stacking_roof_rail_cutout(
                            length = frame_width + cutout_opening_width,
                            opening_width = cutout_opening_width,
                            roof_depth = cutout_roof_depth
                        );
            }
        }
}

/*
 * Vier robuste Auflagen definieren die Stapelhöhe und halten die konischen
 * Flanken spannungsfrei. Eine geringe modellierte Überlappung verbindet die
 * Auflagen zuverlässig mit Feder und Testplatte.
 */
module stacking_seating_lands(
    length,
    width,
    offset_x,
    offset_y,
    height,
    radius,
    boolean_overlap
) {
    assert(
        length >= stacking_min_feature_thickness &&
        width >= stacking_min_feature_thickness,
        "Die Stapelauflagen unterschreiten die minimale Featurestärke."
    );
    assert(height > 0, "Die Stapelauflagen benötigen eine positive Höhe.");

    for (side_x = [-1, 1]) {
        for (side_y = [-1, 1]) {
            translate([
                side_x * offset_x - (length / 2),
                side_y * offset_y -
                    ((width + (2 * boolean_overlap)) / 2),
                -boolean_overlap
            ])
                rounded_prism(
                    length = length,
                    width = width + (2 * boolean_overlap),
                    height = height + boolean_overlap,
                    radius = radius,
                    resolution = curve_resolution
                );
        }
    }
}
