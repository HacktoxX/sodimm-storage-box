/*
 * Zentrale Auswahl des Rendermodus.
 *
 * Die Auswahl an dieser Stelle erhält RAM_Box.scad als reinen Include-Einstieg.
 */

if (render_mode == "debug") {
    if (debug_mode) {
        debug_configuration();
    }

    debug_preview();
} else if (render_mode == "slot_test") {
    slot_test();
} else if (render_mode == "full_box") {
    full_box();
} else if (render_mode == "full_box_short") {
    full_box_short();
} else if (render_mode == "stacking_test") {
    stacking_test();
} else if (render_mode == "stacking_test_variants") {
    stacking_test_variants();
}
