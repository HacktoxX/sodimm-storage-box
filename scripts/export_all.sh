#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
entry_file="${repository_root}/src/RAM_Box.scad"
openscad_helper="${script_directory}/lib/openscad.sh"
calibration_directory="${repository_root}/exports/calibration"
export_directory="$(mktemp -d)"

cleanup() {
    rm -rf "${export_directory}"
}
trap cleanup EXIT

# shellcheck source=lib/openscad.sh
source "${openscad_helper}"
openscad_bin="$(find_openscad)"

render_stl() {
    local description="$1"
    local temporary_output="$2"
    shift 2
    local render_log="${temporary_output}.log"

    printf '%s\n' "Rendering ${description}..."
    if ! "${openscad_bin}" \
        "$@" \
        -o "${temporary_output}" \
        "${entry_file}" >"${render_log}" 2>&1; then
        cat "${render_log}" >&2
        printf '%s\n' "OpenSCAD failed while rendering ${description}." >&2
        return 1
    fi

    if grep -Eiq 'warning|error:' "${render_log}"; then
        cat "${render_log}" >&2
        printf '%s\n' \
            "OpenSCAD reported a diagnostic while rendering ${description}." \
            >&2
        return 1
    fi

    if [[ ! -s "${temporary_output}" ]]; then
        printf '%s\n' "OpenSCAD produced an empty file for ${description}." >&2
        return 1
    fi
}

slot_test_temporary="${export_directory}/sodimm-slot-test.stl"
slot_variants_temporary="${export_directory}/sodimm-slot-variants.stl"

render_stl \
    "the four-slot calibration body" \
    "${slot_test_temporary}" \
    -D 'render_mode="slot_test"' \
    -D 'slot_test_variant_mode=false' \
    -D 'debug_mode=false'

render_stl \
    "the clearance-variant bodies" \
    "${slot_variants_temporary}" \
    -D 'render_mode="slot_test"' \
    -D 'slot_test_variant_mode=true' \
    -D 'debug_mode=false'

mkdir -p "${calibration_directory}"
mv -f \
    "${slot_test_temporary}" \
    "${calibration_directory}/sodimm-slot-test.stl"
mv -f \
    "${slot_variants_temporary}" \
    "${calibration_directory}/sodimm-slot-variants.stl"

printf '%s\n' "STL export completed:"
printf '  %s\n' \
    "${calibration_directory}/sodimm-slot-test.stl" \
    "${calibration_directory}/sodimm-slot-variants.stl"
