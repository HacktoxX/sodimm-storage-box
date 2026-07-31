#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
entry_file="${repository_root}/src/RAM_Box.scad"
mesh_checker="${script_directory}/check_ascii_stl.py"
validation_directory="$(mktemp -d)"

cleanup() {
    rm -rf "${validation_directory}"
}
trap cleanup EXIT

find_openscad() {
    if [[ -n "${SODIMM_OPENSCAD_BIN:-}" ]]; then
        printf '%s\n' "${SODIMM_OPENSCAD_BIN}"
    elif command -v openscad >/dev/null 2>&1; then
        command -v openscad
    elif [[ -x "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" ]]; then
        printf '%s\n' "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
    elif [[ -x "/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD" ]]; then
        printf '%s\n' "/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD"
    else
        printf '%s\n' "OpenSCAD CLI not found." >&2
        return 1
    fi
}

openscad_bin="$(find_openscad)"

fail_on_render_diagnostics() {
    local log_file="$1"

    if grep -Eiq 'warning|error:' "${log_file}"; then
        printf '%s\n' "Unexpected OpenSCAD diagnostic:" >&2
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
        printf '%s\n' "Expected assertion '${name}' did not fire." >&2
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
test -s "${normal_stl}"
python3 "${mesh_checker}" \
    "${normal_stl}" \
    --components 1 \
    --size 152 20 31.4

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
    --size 152 85.2 31.4 \
    --min-y-gap 12

expect_assertion \
    "negative-chamfer-height" \
    "slot_chamfer_height=-0.1" \
    "slot_chamfer_height must be positive."
expect_assertion \
    "negative-chamfer-expansion" \
    "slot_chamfer_expansion=-0.1" \
    "slot_chamfer_expansion cannot be negative."
expect_assertion \
    "chamfer-over-45-degrees" \
    "slot_chamfer_expansion=1.3" \
    "slot_chamfer_expansion cannot exceed slot_chamfer_height"
expect_assertion \
    "invalid-render-mode" \
    'render_mode="invalid"' \
    "render_mode must be"
expect_assertion \
    "invalid-test-rows" \
    "slot_test_rows=0" \
    "slot_test_rows must be a whole number of at least 1."
expect_assertion \
    "invalid-test-columns" \
    "slot_test_columns=0" \
    "slot_test_columns must be a whole number of at least 1."

invalid_width_log="${validation_directory}/invalid-slot-width.log"
"${openscad_bin}" \
    -o "${validation_directory}/invalid-slot-width.csg" \
    "${repository_root}/tests/slot_cutout_invalid_width.scad" \
    >"${invalid_width_log}" 2>&1 || true
if ! grep -Fq "ERROR: Assertion" "${invalid_width_log}" ||
    ! grep -Fq "SO-DIMM slot cutout dimensions must be positive." \
        "${invalid_width_log}"; then
    printf '%s\n' "Expected zero-width slot assertion did not fire." >&2
    cat "${invalid_width_log}" >&2
    exit 1
fi

printf '%s\n' "Slot-test validation passed."
