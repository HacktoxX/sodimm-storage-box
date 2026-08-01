#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
entry_file="${repository_root}/src/RAM_Box.scad"
mesh_checker="${script_directory}/check_ascii_stl.py"
openscad_helper="${script_directory}/lib/openscad.sh"
validation_directory="$(mktemp -d)"

cleanup() {
    rm -rf "${validation_directory}"
}
trap cleanup EXIT

# shellcheck source=lib/openscad.sh
source "${openscad_helper}"
openscad_bin="$(find_openscad)"

fail_on_render_diagnostics() {
    local log_file="$1"

    if grep -Eiq 'warning|error:' "${log_file}"; then
        printf '%s\n' "Unerwartete OpenSCAD-Diagnose:" >&2
        cat "${log_file}" >&2
        return 1
    fi
}

expect_log_message() {
    local log_file="$1"
    local expected_message="$2"
    local description="$3"

    if ! grep -Fq "${expected_message}" "${log_file}"; then
        printf '%s\n' "Erwartete Diagnose fehlt: ${description}." >&2
        cat "${log_file}" >&2
        return 1
    fi
}

expect_assertion() {
    local name="$1"
    local definition="$2"
    local expected_message="$3"
    local log_file="${validation_directory}/${name}.log"

    "${openscad_bin}" \
        -D 'render_mode="stacking_test"' \
        -D "${definition}" \
        -o "${validation_directory}/${name}.csg" \
        "${entry_file}" >"${log_file}" 2>&1 || true

    if ! grep -Fq "ERROR: Assertion" "${log_file}" ||
        ! grep -Fq "${expected_message}" "${log_file}"; then
        printf '%s\n' "Die erwartete Assertion '${name}' wurde nicht ausgelöst." >&2
        cat "${log_file}" >&2
        return 1
    fi
}

standard_stl="${validation_directory}/stacking-test.stl"
standard_log="${validation_directory}/stacking-test.log"
"${openscad_bin}" \
    -D 'render_mode="stacking_test"' \
    -D 'debug_mode=true' \
    -o "${standard_stl}" \
    "${entry_file}" >"${standard_log}" 2>&1
fail_on_render_diagnostics "${standard_log}"
test -s "${standard_stl}"

expect_log_message "${standard_log}" "Gesamtspiel: 0.25 mm" "Standard-Gesamtspiel"
expect_log_message "${standard_log}" "Spiel je Seite: 0.125 mm" "symmetrisches Flankenspiel"
expect_log_message "${standard_log}" "Berechnetes Gesamtspiel: 0.25 mm" "abgeleitetes Gesamtspiel"
expect_log_message "${standard_log}" "Flankenwinkel: 45 Grad" "supportfreier Flankenwinkel"
expect_log_message "${standard_log}" "Federhöhe: 2.2 mm" "moderate Federhöhe"
expect_log_message "${standard_log}" "Federbasis: 6.8 mm" "robuste Federbasis"
expect_log_message "${standard_log}" "Federkrone: 2.4 mm" "minimale Kronenbreite"
expect_log_message "${standard_log}" "Führungstiefe: 1 mm" "tatsächliche Führungstiefe"
expect_log_message "${standard_log}" "Zentrierweg je Achse: 1.125 mm" "rechnerischer Zentrierweg"
expect_log_message "${standard_log}" "Vertikaler Modulfreiraum: 0.2 mm" "Modulfreiraum im Stapel"
expect_log_message "${standard_log}" "Nutöffnung: 4.65 mm" "weibliche Nutöffnung"
expect_log_message "${standard_log}" "Nuttiefe: 2.325 mm" "supportfreie Nuttiefe"
expect_log_message "${standard_log}" "Verbleibende Nut-Rückwand: 2.475 mm" "tragende Rückwand"
expect_log_message "${standard_log}" "Horizontale Auflagefläche: 76.8 mm^2" "definierte Auflage"
expect_log_message "${standard_log}" "Außenkantenabstand: 5.6 x 3.6 mm" "Außenkantenabstand"
expect_log_message "${standard_log}" "Testpaar-Bounding-Box: 70 x 58 x 4.8 mm" "Testpaarabmessungen"
expect_log_message "${standard_log}" "P1S / konfigurierter Bauraum: OK" "P1S-Bauraum"

python3 "${mesh_checker}" \
    "${standard_stl}" \
    --components 2 \
    --size 70 58 4.8 \
    --volume-range 13000 14500

variants_stl="${validation_directory}/stacking-test-variants.stl"
variants_log="${validation_directory}/stacking-test-variants.log"
"${openscad_bin}" \
    -D 'render_mode="stacking_test_variants"' \
    -D 'debug_mode=true' \
    -o "${variants_stl}" \
    "${entry_file}" >"${variants_log}" 2>&1
fail_on_render_diagnostics "${variants_log}"
test -s "${variants_stl}"

for clearance in 0.2 0.25 0.3 0.35; do
    expect_log_message \
        "${variants_log}" \
        "Gesamtspiel: ${clearance} mm" \
        "Stapelvariante ${clearance} mm"
done
expect_log_message \
    "${variants_log}" \
    "Varianten-Bounding-Box: 150 x 126 x 4.8 mm" \
    "Variantenabmessungen"
expect_log_message \
    "${variants_log}" \
    "Varianten im P1S / konfigurierten Bauraum: OK" \
    "P1S-Bauraum der Varianten"

python3 "${mesh_checker}" \
    "${variants_stl}" \
    --components 8 \
    --size 150 126 4.8 \
    --volume-range 52000 58000

expect_assertion \
    "negative-clearance" \
    "stacking_clearance=-0.1" \
    "stacking_clearance darf nicht negativ sein."
expect_assertion \
    "invalid-feature-height" \
    "stacking_feature_height=1.2" \
    "stacking_standoff muss positiv und kleiner als stacking_feature_height sein."
expect_assertion \
    "unsupported-chamfer" \
    "stacking_chamfer_angle=46" \
    "Stapelfasen über 45 Grad"
expect_assertion \
    "thin-feature-top" \
    "stacking_feature_top_width=2.0" \
    "Die freie Krone der Stapelfeder unterschreitet stacking_min_feature_thickness."
expect_assertion \
    "insufficient-module-clearance" \
    "stacking_standoff=1.1" \
    "Die Stapelhöhe lässt nicht genügend Abstand über den eingesetzten SO-DIMMs."
expect_assertion \
    "thin-female-backing" \
    "stacking_test_top_thickness=4.75" \
    "Eine Stapelvariante lässt zu wenig Material über dem Nutdach stehen."
expect_assertion \
    "insufficient-edge-distance" \
    "stacking_test_body_width=25" \
    "Die Stapelfeder unterschreitet den Mindestabstand zur Außenkante des Testkörpers."
expect_assertion \
    "too-few-variants" \
    "stacking_clearance_variants=[0.20,0.25,0.30]" \
    "stacking_clearance_variants muss mindestens vier Werte enthalten."
expect_assertion \
    "variant-build-volume" \
    "printer_build_y=125.9" \
    "Die Stapeltestvarianten überschreiten den konfigurierten Druckerbauraum."

printf '%s\n' "Prüfung der Stapelkalibrierung erfolgreich."
