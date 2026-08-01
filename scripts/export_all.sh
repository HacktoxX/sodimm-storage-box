#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
entry_file="${repository_root}/src/RAM_Box.scad"
openscad_helper="${script_directory}/lib/openscad.sh"
calibration_directory="${repository_root}/exports/calibration"
prototype_directory="${repository_root}/exports/prototypes"
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

    printf '%s\n' "Rendere ${description} ..."
    if ! "${openscad_bin}" \
        "$@" \
        -o "${temporary_output}" \
        "${entry_file}" >"${render_log}" 2>&1; then
        cat "${render_log}" >&2
        printf '%s\n' "OpenSCAD konnte ${description} nicht rendern." >&2
        return 1
    fi

    if grep -Eiq 'warning|error:' "${render_log}"; then
        cat "${render_log}" >&2
        printf '%s\n' \
            "OpenSCAD meldete beim Rendern von ${description} eine Diagnose." \
            >&2
        return 1
    fi

    if [[ ! -s "${temporary_output}" ]]; then
        printf '%s\n' "OpenSCAD erzeugte für ${description} eine leere Datei." >&2
        return 1
    fi
}

slot_test_temporary="${export_directory}/sodimm-slot-test.stl"
slot_variants_temporary="${export_directory}/sodimm-slot-variants.stl"
full_box_temporary="${export_directory}/sodimm-box-v3-body.stl"
short_box_temporary="${export_directory}/sodimm-box-v3-short.stl"
stacking_test_temporary="${export_directory}/stacking-test.stl"
stacking_variants_temporary="${export_directory}/stacking-test-variants.stl"

render_stl \
    "den Vier-Slot-Kalibrierkörper" \
    "${slot_test_temporary}" \
    -D 'render_mode="slot_test"' \
    -D 'slot_test_variant_mode=false' \
    -D 'debug_mode=false'

render_stl \
    "die Körper der Toleranzvarianten" \
    "${slot_variants_temporary}" \
    -D 'render_mode="slot_test"' \
    -D 'slot_test_variant_mode=true' \
    -D 'debug_mode=false'

render_stl \
    "den vollständigen 20-Slot-Grundkörper" \
    "${full_box_temporary}" \
    -D 'render_mode="full_box"' \
    -D 'debug_mode=false'

render_stl \
    "den verkürzten 2×3-Grundkörper" \
    "${short_box_temporary}" \
    -D 'render_mode="full_box_short"' \
    -D 'debug_mode=false'

render_stl \
    "das Kalibrierpaar der Stapelschnittstelle" \
    "${stacking_test_temporary}" \
    -D 'render_mode="stacking_test"' \
    -D 'debug_mode=false'

render_stl \
    "die Spielvarianten der Stapelschnittstelle" \
    "${stacking_variants_temporary}" \
    -D 'render_mode="stacking_test_variants"' \
    -D 'debug_mode=false'

mkdir -p "${calibration_directory}" "${prototype_directory}"
mv -f \
    "${slot_test_temporary}" \
    "${calibration_directory}/sodimm-slot-test.stl"
mv -f \
    "${slot_variants_temporary}" \
    "${calibration_directory}/sodimm-slot-variants.stl"
mv -f \
    "${full_box_temporary}" \
    "${prototype_directory}/sodimm-box-v3-body.stl"
mv -f \
    "${short_box_temporary}" \
    "${prototype_directory}/sodimm-box-v3-short.stl"
mv -f \
    "${stacking_test_temporary}" \
    "${calibration_directory}/stacking-test.stl"
mv -f \
    "${stacking_variants_temporary}" \
    "${calibration_directory}/stacking-test-variants.stl"

printf '%s\n' "STL-Export abgeschlossen:"
printf '  %s\n' \
    "${calibration_directory}/sodimm-slot-test.stl" \
    "${calibration_directory}/sodimm-slot-variants.stl" \
    "${calibration_directory}/stacking-test.stl" \
    "${calibration_directory}/stacking-test-variants.stl" \
    "${prototype_directory}/sodimm-box-v3-body.stl" \
    "${prototype_directory}/sodimm-box-v3-short.stl"
