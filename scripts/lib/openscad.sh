#!/usr/bin/env bash

# OpenSCAD für lokale Prüfungen, Exporte und CI einheitlich ermitteln.
find_openscad() {
    if [[ -n "${SODIMM_OPENSCAD_BIN:-}" ]]; then
        if [[ ! -x "${SODIMM_OPENSCAD_BIN}" ]]; then
            printf '%s\n' \
                "SODIMM_OPENSCAD_BIN ist nicht ausführbar: ${SODIMM_OPENSCAD_BIN}" \
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
            "OpenSCAD wurde weder im PATH noch in einem unterstützten macOS-Programmpaket gefunden." \
            >&2
        printf '%s\n' \
            "OpenSCAD installieren oder SODIMM_OPENSCAD_BIN auf die ausführbare Datei setzen." \
            >&2
        return 1
    fi
}

# OpenSCAD 2021.01 unter macOS verwendet eine neuere Fontconfig-Datei als die
# gebündelte Bibliothek vollständig versteht. Die einzelne Meldung zum Element
# "blank" stammt aus dieser Laufzeitumgebung und nicht aus dem SCAD-Modell.
# Alle übrigen Warnungen und Fehler bleiben weiterhin harte Prüffehler.
openscad_log_has_actionable_diagnostics() {
    local log_file="$1"

    awk '
        !/^Fontconfig warning: .*unknown element "blank"$/ {
            print
        }
    ' "${log_file}" | grep -Eiq 'warning|error:'
}
