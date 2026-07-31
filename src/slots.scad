/*
 * Parametric SO-DIMM slot feature family.
 *
 * This milestone implements only the reusable negative geometry required by
 * the calibration body. It does not place the production 2 x 10 slot array.
 */

/*
 * Creates one slot-shaped subtraction volume centered on X and Y.
 *
 * The lower section is a straight guide. The upper section expands equally on
 * all four sides, so chamfer_expansion <= chamfer_height limits each entry
 * surface to a support-free 45-degree slope.
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
        "SO-DIMM slot cutout dimensions must be positive."
    );
    assert(
        chamfer_height > 0 && chamfer_height < depth,
        "Slot chamfer height must be positive and smaller than slot depth."
    );
    assert(
        chamfer_expansion >= 0 &&
        chamfer_expansion <= chamfer_height,
        "Slot chamfer expansion must remain between zero and chamfer height."
    );
    assert(
        boolean_overlap >= 0,
        "Boolean overlap cannot be negative."
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
 * Extends only the central part of the slot below its nominal support plane.
 * The untouched regions at both X ends become flat PCB support rails, keeping
 * the contact edge suspended above the relieved floor.
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
        "Contact support rails must leave a positive central relief length."
    );
    assert(
        width > 0 && relief_depth > 0,
        "Contact relief width and depth must be positive."
    );
    assert(
        boolean_overlap >= 0,
        "Boolean overlap cannot be negative."
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
