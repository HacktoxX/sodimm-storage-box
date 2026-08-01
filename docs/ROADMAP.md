# Roadmap

## Projektstatus: abgeschlossen

Der definierte Projektumfang ist umgesetzt. Die finale Ausgabe ist eine
offene, einteilige und supportfrei konstruierte SO-DIMM-Aufbewahrungsbox ohne
Deckel oder Zubehör. Weitere Entwicklungsmeilensteine sind für diese Version
nicht vorgesehen.

## Abgeschlossene Kernkonstruktion

- [x] Modulare OpenSCAD-Architektur und zentrale parametrische Maßkette.
- [x] Assertions einschließlich P1S-Bauraumprüfung.
- [x] Physisch kalibrierte Slotlänge von 73,2 mm.
- [x] Physisch kalibriertes Dickenspiel von 1,2 mm und 5,4 mm freie
  Slotbreite.
- [x] Vollständige 2×10-Matrix für 20 SO-DIMMs.
- [x] Gerundeter Grundkörper mit geschlossenem Boden, Reihenstegen,
  Mittelsteg, Kontaktentlastungen und Materialreliefs.
- [x] Funktionale supportfreie Entnahmezone.
- [x] Separate Stapelkalibrierung mit vier Spielvarianten.
- [x] Physisch bestätigtes Stapelgesamtspiel von 0,25 mm.
- [x] Selbstzentrierende 45-Grad-Nut-/Feder-Schnittstelle ohne Clips oder
  Snap-Fits.
- [x] Integration der validierten Stapelmodule in die finale 20-Slot-Box.
- [x] Variables, automatisch skaliertes Beschriftungsfeld mit gravierter und
  geschützt erhabener Darstellung.
- [x] Kollisionsfreie Einzelbox und Zweierstapel geometrisch validiert.
- [x] Finale STL unter `exports/final/sodimm-storage-box-final.stl`
  reproduzierbar erzeugt.

## Abgeschlossene Build- und Qualitätssicherung

- [x] Ein-Befehl-Export aller STL-Dateien.
- [x] OpenSCAD-Renderprüfungen ohne Warnungen.
- [x] Parameter-Negativtests und P1S-Bauraumprüfungen.
- [x] Manifold-, Komponenten-, Bounding-Box- und Volumenprüfung.
- [x] Geometrische Kollisionssonde für zwei vollständige Boxen.
- [x] GitHub Actions für Validierung und STL-Artefakte.

## Bewusst nicht Bestandteil dieses Projekts

- Deckel oder Abdeckung
- Clips oder Snap-Fits
- Magnetaufnahmen
- Gridfinity-Adapter
- Wandhalterung
- DIMM- oder M.2-Varianten
- weiteres Zubehör

Solche Funktionen wären eigenständige Folgeprojekte und ändern den
abgeschlossenen Umfang dieser offenen SO-DIMM-Aufbewahrungsbox nicht.
