#!/usr/bin/env bash

# Resolve OpenSCAD consistently for local validation, exports, and CI.
find_openscad() {
    if [[ -n "${SODIMM_OPENSCAD_BIN:-}" ]]; then
        if [[ ! -x "${SODIMM_OPENSCAD_BIN}" ]]; then
            printf '%s\n' \
                "SODIMM_OPENSCAD_BIN is not executable: ${SODIMM_OPENSCAD_BIN}" \
                >&2
            return 1
        fi
        printf '%s\n' "${SODIMM_OPENSCAD_BIN}"
    elif command -v openscad >/dev/null 2>&1; then
        command -v openscad
    elif [[ -x "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" ]]; then
        printf '%s\n' "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
    elif [[ -x "/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD" ]]; then
        printf '%s\n' "/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD"
    else
        printf '%s\n' \
            "OpenSCAD was not found in PATH or a supported macOS app bundle." \
            >&2
        printf '%s\n' \
            "Install OpenSCAD or set SODIMM_OPENSCAD_BIN to its executable." \
            >&2
        return 1
    fi
}
