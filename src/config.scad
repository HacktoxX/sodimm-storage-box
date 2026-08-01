/*
 * Nutzerseitige Projektkonfiguration.
 *
 * Jeder Wert in dieser Datei ist für sichere und sinnvolle Anpassungen
 * vorgesehen. Berechnungen, Assertions und Geometrie gehören in die dafür
 * zuständigen Quelldateien.
 *
 * Alle Maße sind in Millimetern angegeben, sofern nicht anders vermerkt.
 */

// Nominelle Gesamthülle des SO-DIMMs.
sodimm_length = 72.0;
sodimm_height = 30.0;
sodimm_thickness = 4.2;

// Passungsspiele des Slots.
slot_length_clearance = 1.2;
slot_thickness_clearance = 1.2;

// Supportfreie Sloteinführung und Schutz der Kontaktkante.
slot_chamfer_height = 1.2;
slot_chamfer_expansion = 0.8;
slot_contact_support_length = 5.0;
slot_contact_relief_depth = 0.8;

// Aufbewahrungskapazität und Anordnung.
slots_per_row = 2;
row_count = 10;

// Abstände zwischen Slots und Slotgruppen.
center_gap = 8.0;
row_spacing = 3.2;

// Hauptabmessungen des Gehäuses.
wall_thickness = 3.2;
bottom_thickness = 2.4;
outer_margin_x = 5.0;
outer_margin_y = 5.0;
corner_radius = 4.0;
curve_resolution = 48;
body_material_reliefs = true;

// Vertikaler Eingriff des SO-DIMMs.
insertion_depth = 29.0;

// Funktionale, supportfreie Entnahmezone.
access_grip_depth = 8.0;

// Selbstzentrierende Stapelschnittstelle.
// stacking_clearance ist das horizontale Gesamtspiel, nicht das Spiel je Seite.
// 0,25 mm wurde mit PETG auf dem Bambu Lab P1S physisch validiert.
stacking_clearance = 0.25;
stacking_feature_height = 2.2;
stacking_feature_top_width = 2.4;
stacking_chamfer_angle = 45;
stacking_standoff = 1.2;
stacking_module_vertical_clearance = 0.2;
stacking_min_feature_thickness = 2.4;
stacking_min_edge_distance = 3.2;
stacking_min_backing_thickness = 2.4;

// Kompaktes Kalibrierpaar der Stapelschnittstelle.
stacking_test_body_length = 70.0;
stacking_test_body_width = 26.0;
stacking_test_bottom_thickness = 2.4;
stacking_test_top_thickness = 4.8;
stacking_test_corner_radius = 3.2;
stacking_test_frame_length = 52.0;
stacking_test_frame_width = 12.0;
stacking_test_part_spacing = 6.0;
stacking_test_variant_spacing = 10.0;
stacking_test_variant_columns = 2;
stacking_clearance_variants = [0.20, 0.25, 0.30, 0.35];
stacking_support_land_length = 8.0;
stacking_support_land_width = 2.4;
stacking_support_land_offset_x = 12.0;
stacking_support_land_offset_y = 1.4;
stacking_test_mark_height = 4.0;
stacking_test_mark_depth = 0.4;

// Adaptive Beschriftung.
label_text = "PC4-3200";
label_mode = "engraved"; // "engraved", "raised" oder "disabled".
label_width = 58;
label_height = 11;
label_depth = 0.6;
label_max_font_size = 6.0;
label_min_font_size = 3.0;

// Zieldrucker und Druckprozess.
printer_build_x = 256;
printer_build_y = 256;
printer_build_z = 256;
nozzle_diameter = 0.4;
layer_height = 0.2;

// Vier-Slot-Kalibrierkörper.
slot_test_rows = 2;
slot_test_columns = 2;
slot_test_outer_margin = 3.2;
slot_test_variant_mode = false;
slot_test_clearance_variants = [0.8, 1.0, 1.2];
slot_test_variant_spacing = 12.0;

// Verkürzter Grundkörper für einen schnellen 2×3-Testdruck.
full_box_short_rows = 3;

// Auswahl des Rendermodus und Diagnoseausgabe.
// Erlaubt: "debug", "slot_test", "full_box", "full_box_short",
// "stacking_test", "stacking_test_variants", "final_box".
render_mode = "slot_test";
debug_mode = true;
