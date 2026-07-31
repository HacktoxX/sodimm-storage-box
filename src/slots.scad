/*
 * Parametrische Merkmalsfamilie für SO-DIMM-Slots.
 *
 * Dieser Meilenstein implementiert nur die wiederverwendbare Negativgeometrie
 * des Kalibrierkörpers. Die spätere 2×10-Slotmatrix wird noch nicht angeordnet.
 */

/*
 * Erzeugt ein in X und Y zentriertes, slotförmiges Subtraktionsvolumen.
 *
 * Der untere Abschnitt ist eine gerade Führung. Der obere Abschnitt erweitert
 * sich an allen vier Seiten gleichmäßig. chamfer_expansion <= chamfer_height
 * begrenzt dadurch jede Einführfläche auf supportfreie 45 Grad.
 */
module sodimm_slot_cutout(
    length,
    width,
    depth,
    chamfer_height,
    chamfer_expansion,
    boolean_overlap
) {
    straight_depth = depth - chamfer_height;
    chamfer_scale = [
        (length + (2 * chamfer_expansion)) / length,
        (width + (2 * chamfer_expansion)) / width
    ];

    assert(
        length > 0 && width > 0 && depth > 0,
        "Die Maße des SO-DIMM-Slotausschnitts müssen positiv sein."
    );
    assert(
        chamfer_height > 0 && chamfer_height < depth,
        "Die Höhe der Slotfase muss positiv und kleiner als die Slottiefe sein."
    );
    assert(
        chamfer_expansion >= 0 &&
        chamfer_expansion <= chamfer_height,
        "Die Erweiterung der Slotfase muss zwischen null und der Fasenhöhe liegen."
    );
    assert(
        boolean_overlap >= 0,
        "Die Boolean-Überlappung darf nicht negativ sein."
    );

    union() {
        translate([-length / 2, -width / 2, 0])
            cube([
                length,
                width,
                straight_depth + boolean_overlap
            ]);

        translate([0, 0, straight_depth])
            linear_extrude(
                height = chamfer_height + boolean_overlap,
                scale = chamfer_scale
            )
                square([length, width], center = true);
    }
}

/*
 * Vertieft nur den mittleren Teil des Slots unter seine nominelle Auflageebene.
 * Die unveränderten Bereiche an beiden X-Enden werden zu flachen
 * Platinenauflagen und halten die Kontaktkante über dem freigestellten Boden.
 */
module sodimm_contact_relief_cutout(
    length,
    width,
    support_length,
    relief_depth,
    boolean_overlap
) {
    relief_length = length - (2 * support_length);

    assert(
        support_length > 0 && relief_length > 0,
        "Die Kontaktauflagen müssen eine positive mittige Freistellung lassen."
    );
    assert(
        width > 0 && relief_depth > 0,
        "Breite und Tiefe der Kontaktfreistellung müssen positiv sein."
    );
    assert(
        boolean_overlap >= 0,
        "Die Boolean-Überlappung darf nicht negativ sein."
    );

    translate([
        -relief_length / 2,
        -width / 2,
        -relief_depth
    ])
        cube([
            relief_length,
            width,
            relief_depth + boolean_overlap
        ]);
}
