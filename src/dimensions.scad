/*
 * Zentrale abgeleitete Maße.
 *
 * Koordinatenkonvention:
 *   X: entlang der langen Kante jedes SO-DIMMs
 *   Y: quer zu den Aufbewahrungsreihen
 *   Z: vom tiefsten Stapelmerkmal bis zur offenen Oberseite
 *
 * Merkmalsmodule verwenden diese Werte statt Berechnungen zu wiederholen.
 * Alle Maße sind in Millimetern angegeben, sofern nicht anders vermerkt.
 */

// Primitive Eingaben prüfen, bevor abgeleitete Werte durch sie dividieren.
assert(
    sodimm_length > 0 && sodimm_height > 0 && sodimm_thickness > 0,
    "Alle nominellen SO-DIMM-Maße müssen positiv sein."
);
assert(
    slots_per_row >= 1 && slots_per_row == floor(slots_per_row),
    "slots_per_row muss eine ganze Zahl von mindestens 1 sein."
);
assert(
    row_count >= 1 && row_count == floor(row_count),
    "row_count muss eine ganze Zahl von mindestens 1 sein."
);
assert(
    full_box_short_rows >= 1 &&
    full_box_short_rows <= row_count &&
    full_box_short_rows == floor(full_box_short_rows),
    "full_box_short_rows muss eine ganze Zahl zwischen 1 und row_count sein."
);
assert(
    nozzle_diameter > 0,
    "nozzle_diameter muss positiv sein."
);
assert(
    layer_height > 0,
    "layer_height muss positiv sein."
);
assert(
    wall_thickness >= (2 * nozzle_diameter),
    "wall_thickness muss mindestens zwei Düsendurchmessern entsprechen."
);
assert(
    bottom_thickness >= (3 * layer_height),
    "bottom_thickness muss mindestens drei Druckschichten entsprechen."
);
assert(
    slot_length_clearance >= 0,
    "slot_length_clearance darf nicht negativ sein."
);
assert(
    slot_thickness_clearance >= 0,
    "slot_thickness_clearance darf nicht negativ sein."
);
assert(
    center_gap >= 0 && row_spacing >= 0,
    "Slotabstände dürfen nicht negativ sein."
);
assert(
    outer_margin_x >= 0 && outer_margin_y >= 0,
    "Außenränder dürfen nicht negativ sein."
);
assert(
    curve_resolution >= 12 &&
    curve_resolution == floor(curve_resolution),
    "curve_resolution muss eine ganze Zahl von mindestens 12 sein."
);
assert(
    body_material_reliefs == true || body_material_reliefs == false,
    "body_material_reliefs muss true oder false sein."
);
assert(
    insertion_depth > 0 && insertion_depth <= sodimm_height,
    "insertion_depth muss positiv sein und darf sodimm_height nicht überschreiten."
);
assert(
    access_grip_depth > 0 && access_grip_depth < insertion_depth,
    "access_grip_depth muss positiv und kleiner als insertion_depth sein."
);
assert(
    stacking_clearance >= 0,
    "stacking_clearance darf nicht negativ sein."
);
assert(
    stacking_feature_height > 0 && stacking_feature_width > 0,
    "Die Maße der Stapelfunktion müssen positiv sein."
);
assert(
    stacking_chamfer_angle > 0 && stacking_chamfer_angle <= 45,
    "Stapelfasen über 45 Grad sind nicht garantiert supportfrei druckbar."
);
assert(
    corner_radius >= wall_thickness,
    "corner_radius muss für einen gültigen Innenradius mindestens wall_thickness entsprechen."
);
assert(
    label_mode == "engraved" ||
    label_mode == "raised" ||
    label_mode == "disabled",
    "label_mode muss \"engraved\", \"raised\" oder \"disabled\" sein."
);
assert(
    label_width > 0 && label_height > 0 && label_depth > 0,
    "Die Beschriftungsmaße müssen positiv sein."
);
assert(
    label_depth <= wall_thickness,
    "label_depth darf wall_thickness nicht überschreiten."
);
assert(
    label_min_font_size > 0 &&
    label_min_font_size <= label_max_font_size,
    "label_min_font_size muss positiv und darf nicht größer als label_max_font_size sein."
);
assert(
    printer_build_x > 0 && printer_build_y > 0 && printer_build_z > 0,
    "Die Maße des Druckerbauraums müssen positiv sein."
);

// Ein Slot addiert explizites Fertigungsspiel zur nominellen Modulhülle.
slot_length = sodimm_length + slot_length_clearance;
function slot_width_with_clearance(thickness_clearance) =
    sodimm_thickness + thickness_clearance;
slot_width = slot_width_with_clearance(slot_thickness_clearance);

/*
 * Gemeinsame Matrixfunktionen sind die einzige Quelle für Slotfeld- und
 * Körpermaße. Kalibrierkörper, vollständige Box und Kurztest verwenden damit
 * dieselbe Positions- und Abstandskette.
 */
function slot_matrix_length_for(columns) =
    (columns * slot_length) + ((columns - 1) * center_gap);

function slot_matrix_width_for(rows, thickness_clearance) =
    (rows * slot_width_with_clearance(thickness_clearance)) +
    ((rows - 1) * row_spacing);

function storage_body_length_for(columns) =
    slot_matrix_length_for(columns) +
    (2 * (outer_margin_x + wall_thickness));

function storage_body_width_for(rows, thickness_clearance) =
    slot_matrix_width_for(rows, thickness_clearance) +
    (2 * (outer_margin_y + wall_thickness));

// Das Slotfeld enthält alle Slots und nur die Abstände zwischen Nachbarn.
slot_area_length = slot_matrix_length_for(slots_per_row);
slot_area_width =
    slot_matrix_width_for(row_count, slot_thickness_clearance);

// Der Hauptkörper umschließt das Slotfeld mit Funktionsrand und Außenwand.
body_length = storage_body_length_for(slots_per_row);
body_width = storage_body_width_for(row_count, slot_thickness_clearance);
body_height = bottom_thickness + insertion_depth;

/*
 * Der spätere äußere Stapelsteg bleibt innerhalb der Körpergrundfläche und ist
 * um sein Passungsspiel eingerückt. Seine vollständige Projektion nach unten
 * gehört dennoch zum gesamten Z-Bauraum der Druckerprüfung.
 */
stacking_outer_length = body_length - (2 * stacking_clearance);
stacking_outer_width = body_width - (2 * stacking_clearance);
stacking_inner_length =
    stacking_outer_length - (2 * stacking_feature_width);
stacking_inner_width =
    stacking_outer_width - (2 * stacking_feature_width);

// Gesamter Druckbauraum einschließlich der nach unten ragenden Stapelfunktion.
box_length = max(body_length, stacking_outer_length);
box_width = max(body_width, stacking_outer_width);
box_height = body_height + stacking_feature_height;

// Die Kapazität wird einmal abgeleitet, damit jedes Teilsystem denselben Wert meldet.
total_slot_count = slots_per_row * row_count;

// Der Kurztest reduziert ausschließlich die Reihenzahl derselben Matrix.
full_box_short_slot_count = slots_per_row * full_box_short_rows;
full_box_short_slot_area_length =
    slot_matrix_length_for(slots_per_row);
full_box_short_slot_area_width =
    slot_matrix_width_for(
        full_box_short_rows,
        slot_thickness_clearance
    );
full_box_short_body_length = storage_body_length_for(slots_per_row);
full_box_short_body_width =
    storage_body_width_for(
        full_box_short_rows,
        slot_thickness_clearance
    );
full_box_short_body_height = body_height;

/*
 * Funktionale Entnahmezone und materialoptimierte Randbereiche.
 *
 * Die Randreliefs enden so weit vor den erweiterten Slotöffnungen, dass die
 * minimale Außenwand exakt wall_thickness erhält. Sie sind nach oben offen
 * und erzeugen daher weder Decken noch Brücken.
 */
access_grip_bottom_width = center_gap;
access_grip_top_width =
    access_grip_bottom_width + (2 * access_grip_depth);
access_grip_remaining_web_height = body_height - access_grip_depth;

body_relief_depth_x = outer_margin_x - slot_chamfer_expansion;
body_relief_depth_y = outer_margin_y - slot_chamfer_expansion;
body_relief_corner_radius = wall_thickness / 2;
body_relief_height = body_height - bottom_thickness;
body_calculation_epsilon = layer_height / 100;

body_min_outer_wall_x =
    (wall_thickness + outer_margin_x - slot_chamfer_expansion) -
    body_relief_depth_x;
body_min_outer_wall_y =
    (wall_thickness + outer_margin_y - slot_chamfer_expansion) -
    body_relief_depth_y;
body_load_bearing_row_web_width = row_spacing;
body_entry_row_web_width =
    row_spacing - (2 * slot_chamfer_expansion);
body_center_web_width = center_gap;
body_entry_center_web_width =
    center_gap - (2 * slot_chamfer_expansion);
body_contact_floor_thickness =
    bottom_thickness - slot_contact_relief_depth;

full_box_build_volume_ok =
    body_length <= printer_build_x &&
    body_width <= printer_build_y &&
    body_height <= printer_build_z;
full_box_build_volume_remaining_x = printer_build_x - body_length;
full_box_build_volume_remaining_y = printer_build_y - body_width;
full_box_build_volume_remaining_z = printer_build_z - body_height;

full_box_short_build_volume_ok =
    full_box_short_body_length <= printer_build_x &&
    full_box_short_body_width <= printer_build_y &&
    full_box_short_body_height <= printer_build_z;

// Ursprung des Slotfelds, gemessen von der unteren Außenecke des Körpers.
slot_start_x = wall_thickness + outer_margin_x;
slot_start_y = wall_thickness + outer_margin_y;

// Z-Positionen berücksichtigen das spätere Merkmal unter dem Hauptkörper.
body_start_z = stacking_feature_height;
slot_start_z = body_start_z + bottom_thickness;

// Diagnosewerte werden hier abgeleitet, um Rechnungen in echo() nicht zu wiederholen.
exposed_sodimm_height = sodimm_height - insertion_depth;
wall_line_count = wall_thickness / nozzle_diameter;
bottom_layer_count = bottom_thickness / layer_height;

/*
 * Die Bauraumprüfung verwendet die vollständige druckbare Hülle. box_height
 * enthält bereits das spätere Merkmal unter dem Hauptkörper; X und Y verwenden
 * jeweils die größere Grundfläche von Körper und Stapelfunktion.
 */
build_volume_ok =
    box_length <= printer_build_x &&
    box_width <= printer_build_y &&
    box_height <= printer_build_z;
build_volume_remaining_x = printer_build_x - box_length;
build_volume_remaining_y = printer_build_y - box_width;
build_volume_remaining_z = printer_build_z - box_height;

// Die vollständige Kette abgeleiteter Innen- und Außenmaße prüfen.
assert(
    slot_length > 0 && slot_width > 0,
    "Die abgeleiteten Slotmaße müssen positiv sein."
);
assert(
    slot_area_length > 0 && slot_area_width > 0,
    "Die abgeleiteten Maße des Slotfelds müssen positiv sein."
);
assert(
    body_length > 0 && body_width > 0 && body_height > 0,
    "Die abgeleiteten Körpermaße müssen positiv sein."
);
assert(
    stacking_outer_length > 0 && stacking_outer_width > 0,
    "Die abgeleiteten Außenmaße der Stapelfunktion müssen positiv sein."
);
assert(
    stacking_inner_length > 0 && stacking_inner_width > 0,
    "stacking_feature_width ist für die Stapelschnittstelle zu groß."
);
assert(
    box_length > 0 && box_width > 0 && box_height > 0,
    "Die abgeleiteten Gesamtmaße der Box müssen positiv sein."
);
assert(
    corner_radius <= (min(body_length, body_width) / 2),
    "corner_radius darf die Hälfte der kürzesten Körperabmessung nicht überschreiten."
);
assert(
    exposed_sodimm_height >= 0,
    "Die abgeleitete freiliegende SO-DIMM-Höhe darf nicht negativ sein."
);
assert(
    row_spacing >= wall_thickness,
    "row_spacing muss für einen tragenden Reihensteg mindestens wall_thickness entsprechen."
);
assert(
    center_gap >= wall_thickness,
    "center_gap muss für einen tragenden Mittelsteg mindestens wall_thickness entsprechen."
);
assert(
    access_grip_remaining_web_height >=
        (bottom_thickness + wall_thickness),
    "Die Entnahmezone lässt zu wenig tragende Höhe im Mittelsteg stehen."
);
assert(
    body_entry_row_web_width > 0,
    "Die Einführfasen benachbarter Reihen kollidieren."
);
assert(
    body_entry_center_web_width >= wall_thickness,
    "Die Einführfasen lassen am Mittelsteg weniger als wall_thickness stehen."
);
assert(
    body_contact_floor_thickness >= (3 * layer_height),
    "Der Boden unter der Kontaktentlastung muss mindestens drei Schichten stark bleiben."
);
assert(
    !body_material_reliefs ||
    (
        body_relief_depth_x > 0 &&
        body_relief_depth_y > 0 &&
        body_relief_height > 0
    ),
    "Die aktivierten Materialreliefs benötigen positive Abmessungen."
);
assert(
    !body_material_reliefs ||
    (
        body_min_outer_wall_x + body_calculation_epsilon >= wall_thickness &&
        body_min_outer_wall_y + body_calculation_epsilon >= wall_thickness
    ),
    "Die Materialreliefs unterschreiten die minimale Außenwandstärke."
);
assert(
    body_length <= printer_build_x,
    str(
        "Die Grundkörperlänge von ",
        body_length,
        " mm überschreitet printer_build_x von ",
        printer_build_x,
        " mm."
    )
);
assert(
    body_width <= printer_build_y,
    str(
        "Die Grundkörperbreite von ",
        body_width,
        " mm überschreitet printer_build_y von ",
        printer_build_y,
        " mm."
    )
);
assert(
    body_height <= printer_build_z,
    str(
        "Die Grundkörperhöhe von ",
        body_height,
        " mm überschreitet printer_build_z von ",
        printer_build_z,
        " mm."
    )
);
assert(
    full_box_short_body_length <= printer_build_x,
    "Der kurze Grundkörper überschreitet printer_build_x."
);
assert(
    full_box_short_body_width <= printer_build_y,
    "Der kurze Grundkörper überschreitet printer_build_y."
);
assert(
    full_box_short_body_height <= printer_build_z,
    "Der kurze Grundkörper überschreitet printer_build_z."
);

// Auf genau der Druckerachse fehlschlagen, die die Box nicht aufnehmen kann.
assert(
    box_length <= printer_build_x,
    str(
        "Die Boxlänge von ",
        box_length,
        " mm überschreitet printer_build_x von ",
        printer_build_x,
        " mm."
    )
);
assert(
    box_width <= printer_build_y,
    str(
        "Die Boxbreite von ",
        box_width,
        " mm überschreitet printer_build_y von ",
        printer_build_y,
        " mm."
    )
);
assert(
    box_height <= printer_build_z,
    str(
        "Die Boxhöhe von ",
        box_height,
        " mm überschreitet printer_build_z von ",
        printer_build_z,
        " mm."
    )
);

/*
 * Vier-Slot-Kalibrierkörper
 *
 * Diese Funktionen halten die Testvarianten parametergesteuert. Die Slotmaße
 * der späteren Box bleiben die verbindliche Quelle; nur das Dickenspiel
 * unterscheidet sich zwischen den Kalibrierkörpern.
 */
function slot_test_field_length_for(columns) =
    slot_matrix_length_for(columns);

function slot_test_field_width_for(thickness_clearance, rows) =
    slot_matrix_width_for(rows, thickness_clearance);

function slot_test_body_length_for(columns) =
    slot_test_field_length_for(columns) + (2 * slot_test_edge_width);

function slot_test_body_width_for(thickness_clearance, rows) =
    slot_test_field_width_for(thickness_clearance, rows) +
    (2 * slot_test_edge_width);

assert(
    render_mode == "debug" ||
    render_mode == "slot_test" ||
    render_mode == "full_box" ||
    render_mode == "full_box_short",
    "render_mode muss \"debug\", \"slot_test\", \"full_box\" oder \"full_box_short\" sein."
);
assert(
    slot_test_rows >= 1 && slot_test_rows == floor(slot_test_rows),
    "slot_test_rows muss eine ganze Zahl von mindestens 1 sein."
);
assert(
    slot_test_columns >= 1 &&
    slot_test_columns == floor(slot_test_columns),
    "slot_test_columns muss eine ganze Zahl von mindestens 1 sein."
);
assert(
    slot_chamfer_height > 0,
    "slot_chamfer_height muss positiv sein."
);
assert(
    slot_chamfer_expansion >= 0,
    "slot_chamfer_expansion darf nicht negativ sein."
);
assert(
    slot_chamfer_expansion <= slot_chamfer_height,
    "slot_chamfer_expansion darf slot_chamfer_height nicht überschreiten; die Einführfläche wäre steiler als 45 Grad."
);
assert(
    slot_chamfer_height < insertion_depth,
    "slot_chamfer_height muss kleiner als insertion_depth sein."
);
assert(
    slot_contact_support_length > 0 &&
    (2 * slot_contact_support_length) < slot_length,
    "slot_contact_support_length muss einen offenen Bereich für die Kontaktfreistellung lassen."
);
assert(
    slot_contact_relief_depth > 0,
    "slot_contact_relief_depth muss positiv sein."
);
assert(
    (bottom_thickness - slot_contact_relief_depth) >= (3 * layer_height),
    "Der Boden unter der Kontaktfreistellung muss mindestens drei Schichten stark bleiben."
);
assert(
    slot_test_outer_margin >= wall_thickness,
    "slot_test_outer_margin muss mindestens wall_thickness erhalten."
);
assert(
    access_grip_depth > 0,
    "access_grip_depth muss positiv sein."
);
assert(
    slot_test_variant_mode == true || slot_test_variant_mode == false,
    "slot_test_variant_mode muss true oder false sein."
);
assert(
    len(slot_test_clearance_variants) >= 1,
    "slot_test_clearance_variants muss mindestens einen Wert enthalten."
);
for (variant_clearance = slot_test_clearance_variants) {
    assert(
        variant_clearance >= 0,
        "Jedes Dickenspiel des Slot-Tests muss nichtnegativ sein."
    );
}
assert(
    slot_test_variant_spacing >= wall_thickness,
    "slot_test_variant_spacing muss mindestens wall_thickness entsprechen."
);

// Der Rand des Testkörpers ist nie dünner als die Wand der späteren Box.
slot_test_edge_width = max(wall_thickness, slot_test_outer_margin);

// Der Test verwendet Slotlänge, Mittelabstand und Reihenabstand der späteren Box.
slot_test_slot_length = slot_length;
slot_test_slot_width =
    slot_width_with_clearance(slot_thickness_clearance);
slot_test_field_length = slot_test_field_length_for(slot_test_columns);
slot_test_field_width =
    slot_test_field_width_for(slot_thickness_clearance, slot_test_rows);

slot_test_body_length = slot_test_body_length_for(slot_test_columns);
slot_test_body_width =
    slot_test_body_width_for(slot_thickness_clearance, slot_test_rows);
slot_test_body_height = bottom_thickness + insertion_depth;

// Die Slotanordnung beginnt hinter der kompakten Außenwand.
slot_test_slot_start_x = slot_test_edge_width;
slot_test_slot_start_y = slot_test_edge_width;
slot_test_slot_start_z = bottom_thickness;

// Die gerade Führung endet am Beginn der symmetrischen oberen Fase.
slot_straight_guide_depth = insertion_depth - slot_chamfer_height;

/*
 * Zwei Endauflagen bleiben auf dem nominellen Bodenniveau stehen. Die
 * Freistellung dazwischen schützt die Kontaktkante und erhält einen
 * druckbaren geschlossenen Boden.
 */
slot_contact_relief_length =
    slot_test_slot_length - (2 * slot_contact_support_length);
slot_contact_floor_thickness =
    bottom_thickness - slot_contact_relief_depth;

/*
 * Die Entnahmeöffnung beginnt mit dem vollständigen Mittelabstand und erweitert
 * sich horizontal um einen Millimeter je vertikalem Millimeter. Ihre
 * 45-Grad-Flächen sind supportfrei.
 */
slot_test_grip_bottom_width = center_gap;
slot_test_grip_top_width = access_grip_top_width;
slot_test_remaining_center_web_height =
    access_grip_remaining_web_height;

// Explizite Stegberechnungen belegen, dass benachbarte Fasen nicht kollidieren.
slot_test_column_web_width = center_gap;
slot_test_row_web_width = row_spacing;
slot_test_chamfer_column_web_width =
    slot_test_column_web_width - (2 * slot_chamfer_expansion);
slot_test_chamfer_row_web_width =
    slot_test_row_web_width - (2 * slot_chamfer_expansion);
slot_test_chamfer_outer_wall =
    slot_test_edge_width - slot_chamfer_expansion;

// Eine aus der Schichthöhe abgeleitete Überlappung vermeidet koplanare Booleans.
modeling_overlap = layer_height / 10;
slot_test_boolean_overlap = modeling_overlap;

// Der Variantenabstand verwendet unabhängig von der Reihenfolge den breitesten Körper.
slot_test_variant_count = len(slot_test_clearance_variants);
slot_test_max_variant_clearance =
    slot_test_variant_count > 0
        ? max(slot_test_clearance_variants)
        : slot_thickness_clearance;
slot_test_max_variant_body_width =
    slot_test_body_width_for(
        slot_test_max_variant_clearance,
        slot_test_rows
    );
slot_test_variant_pitch =
    slot_test_max_variant_body_width + slot_test_variant_spacing;
slot_test_variants_width =
    (slot_test_variant_count * slot_test_max_variant_body_width) +
    ((slot_test_variant_count - 1) * slot_test_variant_spacing);

// Die gesamte Renderhülle wechselt zwischen Einzelkörper und Variantenanordnung.
slot_test_render_length = slot_test_body_length;
slot_test_render_width =
    slot_test_variant_mode
        ? slot_test_variants_width
        : slot_test_body_width;
slot_test_render_height = slot_test_body_height;
slot_test_build_volume_ok =
    slot_test_render_length <= printer_build_x &&
    slot_test_render_width <= printer_build_y &&
    slot_test_render_height <= printer_build_z;

assert(
    slot_test_slot_width > 0,
    "Die abgeleitete Breite des Slot-Tests muss positiv sein."
);
assert(
    slot_test_body_length > 0 &&
    slot_test_body_width > 0 &&
    slot_test_body_height > 0,
    "Alle abgeleiteten Körpermaße des Slot-Tests müssen positiv sein."
);
assert(
    slot_contact_relief_length > 0,
    "Die Kontaktauflagen lassen keine mittige Kontaktfreistellung übrig."
);
assert(
    slot_test_remaining_center_web_height >=
        (bottom_thickness + wall_thickness),
    "Die Entnahmefreistellung lässt über dem Boden weniger als wall_thickness stehen."
);
assert(
    slot_test_chamfer_column_web_width > 0,
    "Die Spaltenfasen kollidieren über center_gap hinweg."
);
assert(
    slot_test_chamfer_row_web_width > 0,
    "Die Reihenfasen kollidieren über row_spacing hinweg."
);
assert(
    slot_test_chamfer_outer_wall >= (2 * nozzle_diameter),
    "Die Fase lässt an der Außenwand weniger als zwei Düsendurchmesser stehen."
);
assert(
    slot_test_render_length <= printer_build_x,
    "Der Slot-Test überschreitet printer_build_x."
);
assert(
    slot_test_render_width <= printer_build_y,
    "Der Slot-Test überschreitet printer_build_y."
);
assert(
    slot_test_render_height <= printer_build_z,
    "Der Slot-Test überschreitet printer_build_z."
);
