/*
 * Geometrische Kollisionssonde für eine zusammengesetzte Stapelschnittstelle.
 *
 * Die 1-mm-Referenzgeometrie bleibt als einziges Netz übrig, wenn männliche
 * Feder und Material der weiblichen Platte in Sollposition kollisionsfrei
 * sind. Jede reale Überschneidung erzeugt zusätzliche Komponenten und eine
 * größere Bounding Box, die das Prüfskript ablehnt.
 */

include <../src/config.scad>
include <../src/helpers.scad>
include <../src/dimensions.scad>
include <../src/stacking.scad>

stacking_collision_check_clearance = 0.25;
stacking_collision_reference_size = 1.0;
stacking_collision_reference_offset = 100.0;

union() {
    translate([stacking_collision_reference_offset, 0, 0])
        cube([
            stacking_collision_reference_size,
            stacking_collision_reference_size,
            stacking_collision_reference_size
        ]);

    intersection() {
        stacking_male_feature(
            frame_length = stacking_test_frame_length,
            frame_width = stacking_test_frame_width,
            feature_height = stacking_feature_height,
            feature_top_width = stacking_feature_top_width,
            chamfer_angle = stacking_chamfer_angle
        );

        translate([0, 0, stacking_standoff])
            difference() {
                translate([
                    -stacking_test_body_length / 2,
                    -stacking_test_body_width / 2,
                    0
                ])
                    rounded_prism(
                        length = stacking_test_body_length,
                        width = stacking_test_body_width,
                        height = stacking_test_top_thickness,
                        radius = stacking_test_corner_radius,
                        resolution = curve_resolution
                    );

                stacking_female_feature(
                    frame_length = stacking_test_frame_length,
                    frame_width = stacking_test_frame_width,
                    feature_height = stacking_feature_height,
                    feature_top_width = stacking_feature_top_width,
                    chamfer_angle = stacking_chamfer_angle,
                    standoff = stacking_standoff,
                    clearance = stacking_collision_check_clearance,
                    boolean_overlap = modeling_overlap
                );
            }
    }
}
