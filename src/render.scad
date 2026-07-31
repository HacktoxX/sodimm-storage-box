/*
 * Top-level render dispatcher.
 *
 * Keeping selection here preserves RAM_Box.scad as an include-only entry point.
 */

if (render_mode == "debug") {
    if (debug_mode) {
        debug_configuration();
    }

    debug_preview();
} else if (render_mode == "slot_test") {
    slot_test();
}
