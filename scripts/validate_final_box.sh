#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
entry_file="${repository_root}/src/RAM_Box.scad"
two_box_file="${repository_root}/tests/final_two_box_stack.scad"
collision_file="${repository_root}/tests/final_stack_collision_check.scad"
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
        -D 'render_mode="final_box"' \
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

final_stl="${validation_directory}/sodimm-storage-box-final.stl"
final_log="${validation_directory}/sodimm-storage-box-final.log"
"${openscad_bin}" \
    -D 'render_mode="final_box"' \
    -D 'debug_mode=true' \
    -o "${final_stl}" \
    "${entry_file}" >"${final_log}" 2>&1
fail_on_render_diagnostics "${final_log}"
test -s "${final_stl}"

expect_log_message "${final_log}" "Slots: 20" "exakt 20 Slots"
expect_log_message "${final_log}" "Anordnung: 2 x 10" "2×10-Anordnung"
expect_log_message "${final_log}" "Slotlänge: 73.2 mm" "physisch validierte Slotlänge"
expect_log_message "${final_log}" "Slotbreite: 5.4 mm" "physisch validierte Slotbreite"
expect_log_message "${final_log}" "Dickenspiel: 1.2 mm" "physisch validiertes Dickenspiel"
expect_log_message "${final_log}" "Slotfeld: 154.4 x 82.8 mm" "Slotfeldgröße"
expect_log_message "${final_log}" "Stapelspiel gesamt: 0.25 mm" "physisch validiertes Stapelspiel"
expect_log_message "${final_log}" "Stapelspiel je Seite: 0.125 mm" "korrekt verteiltes Stapelspiel"
expect_log_message "${final_log}" "Flankenwinkel: 45 Grad" "supportfreie Stapelflanken"
expect_log_message "${final_log}" "Führungstiefe: 1 mm" "Führungstiefe"
expect_log_message "${final_log}" "Vertikaler Modulfreiraum: 0.2 mm" "vertikaler Modulfreiraum"
expect_log_message \
    "${final_log}" \
    "Finale Bounding-Box: 176.8 x 105.2 x 33.6 mm" \
    "finale Bounding Box"
expect_log_message \
    "${final_log}" \
    "Zwei Boxen gestapelt: 176.8 x 105.2 x 66.2 mm" \
    "Bounding Box des Zweierstapels"
expect_log_message \
    "${final_log}" \
    "P1S / konfigurierter Bauraum: OK" \
    "erfolgreiche P1S-Bauraumprüfung"

python3 "${mesh_checker}" \
    "${final_stl}" \
    --components 1 \
    --size 176.8 105.2 33.6 \
    --volume-range 325000 340000

two_box_stl="${validation_directory}/sodimm-final-two-box-stack.stl"
two_box_log="${validation_directory}/sodimm-final-two-box-stack.log"
"${openscad_bin}" \
    -o "${two_box_stl}" \
    "${two_box_file}" >"${two_box_log}" 2>&1
fail_on_render_diagnostics "${two_box_log}"
test -s "${two_box_stl}"

python3 "${mesh_checker}" \
    "${two_box_stl}" \
    --components 2 \
    --size 176.8 105.2 66.2 \
    --volume-range 660000 675000

collision_stl="${validation_directory}/sodimm-final-collision.stl"
collision_log="${validation_directory}/sodimm-final-collision.log"
"${openscad_bin}" \
    -o "${collision_stl}" \
    "${collision_file}" >"${collision_log}" 2>&1
fail_on_render_diagnostics "${collision_log}"
test -s "${collision_stl}"

python3 "${mesh_checker}" \
    "${collision_stl}" \
    --components 1 \
    --size 1 1 1 \
    --volume-range 0.999 1.001

expect_assertion \
    "invalid-render-mode" \
    'render_mode="ungueltig"' \
    "render_mode muss"
expect_assertion \
    "negative-stacking-clearance" \
    "stacking_clearance=-0.1" \
    "stacking_clearance darf nicht negativ sein."
expect_assertion \
    "invalid-stacking-angle" \
    "stacking_chamfer_angle=46" \
    "Stapelfasen über 45 Grad sind nicht garantiert supportfrei druckbar."
expect_assertion \
    "invalid-final-relief" \
    "final_body_relief_depth=0.4" \
    "Die finalen Materialreliefs sind schmaler als zwei Düsenbahnen."
expect_assertion \
    "final-box-build-volume" \
    "printer_build_x=176.7" \
    "Die finale Box überschreitet den konfigurierten Druckerbauraum."

printf '%s\n' "Prüfung der finalen Stapelbox erfolgreich."
