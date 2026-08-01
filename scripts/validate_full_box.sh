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
        -D 'render_mode="full_box"' \
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

full_box_stl="${validation_directory}/sodimm-box-v3-body.stl"
full_box_log="${validation_directory}/sodimm-box-v3-body.log"
"${openscad_bin}" \
    -D 'render_mode="full_box"' \
    -D 'debug_mode=true' \
    -o "${full_box_stl}" \
    "${entry_file}" >"${full_box_log}" 2>&1
fail_on_render_diagnostics "${full_box_log}"
test -s "${full_box_stl}"

expect_log_message "${full_box_log}" "Slots: 20" "exakt 20 Slots"
expect_log_message "${full_box_log}" "Anordnung: 2 x 10" "2×10-Anordnung"
expect_log_message "${full_box_log}" "Slotlänge: 73.2 mm" "validierte Slotlänge"
expect_log_message "${full_box_log}" "Slotbreite: 5.4 mm" "validierte Slotbreite"
expect_log_message "${full_box_log}" "Dickenspiel: 1.2 mm" "validiertes Dickenspiel"
expect_log_message "${full_box_log}" "Slotfeld: 154.4 x 82.8 mm" "Slotfeldgröße"
expect_log_message "${full_box_log}" "Reihenabstand: 3.2 mm" "Reihenabstand"
expect_log_message "${full_box_log}" "Mittelsteg: 8 mm" "Mittelstegbreite"
expect_log_message "${full_box_log}" "Außenwand: 3.2 mm" "Außenwandstärke"
expect_log_message "${full_box_log}" "Kontaktboden: 1.6 mm" "verbleibender Kontaktboden"
expect_log_message "${full_box_log}" "Tragende Höhe unter Entnahmezone: 23.4 mm" "tragende Griffzone"
expect_log_message "${full_box_log}" "Modulüberstand: 1 mm" "Modulüberstand"
expect_log_message \
    "${full_box_log}" \
    "Grundkörper-Bounding-Box: 170.8 x 99.2 x 31.4 mm" \
    "Bounding Box des vollständigen Körpers"
expect_log_message \
    "${full_box_log}" \
    "P1S / konfigurierter Bauraum: OK" \
    "erfolgreiche P1S-Bauraumprüfung"

python3 "${mesh_checker}" \
    "${full_box_stl}" \
    --components 1 \
    --size 170.8 99.2 31.4 \
    --volume-range 230000 250000

short_box_stl="${validation_directory}/sodimm-box-v3-short.stl"
short_box_log="${validation_directory}/sodimm-box-v3-short.log"
"${openscad_bin}" \
    -D 'render_mode="full_box_short"' \
    -D 'debug_mode=true' \
    -o "${short_box_stl}" \
    "${entry_file}" >"${short_box_log}" 2>&1
fail_on_render_diagnostics "${short_box_log}"
test -s "${short_box_stl}"

expect_log_message "${short_box_log}" "Slots: 6" "exakt 6 Slots im Kurztest"
expect_log_message "${short_box_log}" "Anordnung: 2 x 3" "2×3-Kurzanordnung"
expect_log_message "${short_box_log}" "Slotfeld: 154.4 x 22.6 mm" "kurzes Slotfeld"
expect_log_message \
    "${short_box_log}" \
    "Grundkörper-Bounding-Box: 170.8 x 39 x 31.4 mm" \
    "Bounding Box des kurzen Körpers"
expect_log_message \
    "${short_box_log}" \
    "P1S / konfigurierter Bauraum: OK" \
    "P1S-Bauraumprüfung des kurzen Körpers"

python3 "${mesh_checker}" \
    "${short_box_stl}" \
    --components 1 \
    --size 170.8 39 31.4 \
    --volume-range 90000 100000

expect_assertion \
    "invalid-short-rows-zero" \
    "full_box_short_rows=0" \
    "full_box_short_rows muss eine ganze Zahl zwischen 1 und row_count sein."
expect_assertion \
    "invalid-short-rows-large" \
    "full_box_short_rows=11" \
    "full_box_short_rows muss eine ganze Zahl zwischen 1 und row_count sein."
expect_assertion \
    "thin-row-web" \
    "row_spacing=3.0" \
    "row_spacing muss für einen tragenden Reihensteg mindestens wall_thickness entsprechen."
expect_assertion \
    "thin-center-web" \
    "center_gap=3.0" \
    "center_gap muss für einen tragenden Mittelsteg mindestens wall_thickness entsprechen."
expect_assertion \
    "invalid-grip-depth" \
    "access_grip_depth=29" \
    "access_grip_depth muss positiv und kleiner als insertion_depth sein."
expect_assertion \
    "invalid-curve-resolution" \
    "curve_resolution=8" \
    "curve_resolution muss eine ganze Zahl von mindestens 12 sein."
expect_assertion \
    "full-box-build-volume" \
    "printer_build_y=99.1" \
    "Grundkörperbreite von 99.2 mm überschreitet printer_build_y von 99.1 mm."

printf '%s\n' "Prüfung des vollständigen Grundkörpers erfolgreich."
