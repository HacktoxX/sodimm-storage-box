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
}
