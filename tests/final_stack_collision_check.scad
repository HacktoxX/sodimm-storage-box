/*
 * Volumetrische Kollisionssonde für zwei finale Boxen in Stapellage.
 *
 * Die entfernte 1-mm-Referenzgeometrie bleibt als einziges Netz übrig, wenn
 * sich die beiden vollständigen Boxen nur an den vorgesehenen Auflagen
 * berühren. Jede reale Überschneidung vergrößert Komponentenzahl oder Hülle.
 */

include <../src/config.scad>
include <../src/helpers.scad>
include <../src/dimensions.scad>
include <../src/slots.scad>
include <../src/body.scad>
include <../src/stacking.scad>
include <../src/label.scad>
include <../src/final_box.scad>

final_collision_reference_size = 1.0;
final_collision_reference_offset = printer_build_x + 10.0;

union() {
    translate([final_collision_reference_offset, 0, 0])
        cube([
            final_collision_reference_size,
            final_collision_reference_size,
            final_collision_reference_size
        ]);

    intersection() {
        final_storage_box_body();

        translate([0, 0, final_stack_pitch])
            final_storage_box_body();
    }
}
