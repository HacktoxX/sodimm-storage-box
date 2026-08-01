/*
 * Zwei identische finale Boxen in ihrer konstruktiv definierten Stapellage.
 *
 * Dieses Prüfmodell verwendet keine vereinfachte Ersatzgeometrie. Der Abstand
 * der beiden Ursprünge entspricht Körperhöhe plus validierter Auflagehöhe.
 */

include <../src/config.scad>
include <../src/helpers.scad>
include <../src/dimensions.scad>
include <../src/slots.scad>
include <../src/body.scad>
include <../src/stacking.scad>
include <../src/label.scad>
include <../src/final_box.scad>

final_storage_box_body();

translate([0, 0, final_stack_pitch])
    final_storage_box_body();
