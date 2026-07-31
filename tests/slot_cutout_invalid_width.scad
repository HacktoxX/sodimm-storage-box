/*
 * Negative test fixture: direct module invocation proves that reusable slot
 * geometry rejects a zero-width opening independently of global parameters.
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
