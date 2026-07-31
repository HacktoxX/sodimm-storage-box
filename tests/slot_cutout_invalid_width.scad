/*
 * Negativtest: Der direkte Modulaufruf belegt, dass die wiederverwendbare
 * Slotgeometrie unabhängig von globalen Parametern eine Breite von null ablehnt.
 */

include <../src/config.scad>
include <../src/dimensions.scad>
include <../src/slots.scad>

sodimm_slot_cutout(
    length = slot_length,
    width = 0,
    depth = insertion_depth,
    chamfer_height = slot_chamfer_height,
    chamfer_expansion = slot_chamfer_expansion,
    boolean_overlap = slot_test_boolean_overlap
);
