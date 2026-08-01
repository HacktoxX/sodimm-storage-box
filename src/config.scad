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
stacking_clearance = 0.25;
stacking_feature_height = 1.6;
stacking_feature_width = 2.4;
stacking_chamfer_angle = 45;

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
render_mode = "slot_test"; // "debug" oder "slot_test".
debug_mode = true;
