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

normal_stl="${validation_directory}/slot-test.stl"
normal_log="${validation_directory}/slot-test.log"
"${openscad_bin}" \
    -o "${normal_stl}" \
    "${entry_file}" >"${normal_log}" 2>&1
fail_on_render_diagnostics "${normal_log}"
expect_log_message \
    "${normal_log}" \
    "Slotlänge: 73.2 mm" \
    "freie Standard-Slotlänge von 73,2 mm"
test -s "${normal_stl}"
python3 "${mesh_checker}" \
    "${normal_stl}" \
    --components 1 \
    --size 160.8 20.4 31.4

debug_stl="${validation_directory}/debug-preview.stl"
debug_log="${validation_directory}/debug-preview.log"
"${openscad_bin}" \
    -D 'render_mode="debug"' \
    -o "${debug_stl}" \
    "${entry_file}" >"${debug_log}" 2>&1
fail_on_render_diagnostics "${debug_log}"
expect_log_message \
    "${debug_log}" \
    "Slotabmessungen: 73.2 x 5.4 mm" \
    "aktualisierte Slotabmessungen"
expect_log_message \
    "${debug_log}" \
    "P1S / konfigurierter Bauraum: OK" \
    "erfolgreiche P1S-Bauraumprüfung"
test -s "${debug_stl}"
python3 "${mesh_checker}" \
    "${debug_stl}" \
    --components 1 \
    --size 170.8 99.2 33.6

variant_stl="${validation_directory}/slot-variants.stl"
variant_log="${validation_directory}/slot-variants.log"
"${openscad_bin}" \
    -D "slot_test_variant_mode=true" \
    -o "${variant_stl}" \
    "${entry_file}" >"${variant_log}" 2>&1
fail_on_render_diagnostics "${variant_log}"
test -s "${variant_stl}"
python3 "${mesh_checker}" \
    "${variant_stl}" \
    --components 3 \
    --size 160.8 85.2 31.4 \
    --min-y-gap 12

expect_assertion \
    "negative-chamfer-height" \
    "slot_chamfer_height=-0.1" \
    "slot_chamfer_height muss positiv sein."
expect_assertion \
    "negative-chamfer-expansion" \
    "slot_chamfer_expansion=-0.1" \
    "slot_chamfer_expansion darf nicht negativ sein."
expect_assertion \
    "chamfer-over-45-degrees" \
    "slot_chamfer_expansion=1.3" \
    "slot_chamfer_expansion darf slot_chamfer_height nicht überschreiten"
expect_assertion \
    "invalid-render-mode" \
    'render_mode="invalid"' \
    "render_mode muss"
expect_assertion \
    "invalid-test-rows" \
    "slot_test_rows=0" \
    "slot_test_rows muss eine ganze Zahl von mindestens 1 sein."
expect_assertion \
    "invalid-test-columns" \
    "slot_test_columns=0" \
    "slot_test_columns muss eine ganze Zahl von mindestens 1 sein."

invalid_width_log="${validation_directory}/invalid-slot-width.log"
"${openscad_bin}" \
    -o "${validation_directory}/invalid-slot-width.csg" \
    "${repository_root}/tests/slot_cutout_invalid_width.scad" \
    >"${invalid_width_log}" 2>&1 || true
if ! grep -Fq "ERROR: Assertion" "${invalid_width_log}" ||
    ! grep -Fq "Die Maße des SO-DIMM-Slotausschnitts müssen positiv sein." \
        "${invalid_width_log}"; then
    printf '%s\n' "Die erwartete Assertion für eine Slotbreite von null wurde nicht ausgelöst." >&2
    cat "${invalid_width_log}" >&2
    exit 1
fi

printf '%s\n' "Prüfung des Slot-Tests erfolgreich."
