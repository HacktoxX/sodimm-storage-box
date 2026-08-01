# Änderungsprotokoll

Alle wesentlichen Änderungen an diesem Projekt werden in dieser Datei
dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.1.0/).
Das Projekt beabsichtigt, der [semantischen Versionierung](https://semver.org/lang/de/)
zu folgen.

## [Unveröffentlicht]

### Hinzugefügt

- Vollständige parametrische 2×10-Matrix für exakt 20 SO-DIMM-Module.
- Gerundeter tragender Grundkörper mit geschlossenem Boden, Außenwänden,
  Reihenstegen und 8,0-mm-Mittelsteg.
- Durchgehende supportfreie funktionale Entnahmezone auf Basis des
  Kalibrierkörpers.
- Topoffene gerundete Randreliefs, die das Netzvolumen moderat um rund 16,3 %
  reduzieren und mindestens 3,2 mm Außenwand erhalten.
- Optionaler `full_box_short`-Modus mit derselben Körpergeometrie und einer
  2×3-Slotmatrix für einen kürzeren Testdruck.
- Prototyp-Exporte `sodimm-box-v3-body.stl` und
  `sodimm-box-v3-short.stl`.
- Automatisierte Vollkörperprüfung für Slotanzahl, Diagnosewerte, Assertions,
  P1S-Bauraum, Bounding Box, Netzvolumen, Komponenten und Manifold-Topologie.
- Netzvolumenberechnung im ASCII-STL-Prüfwerkzeug.

### Behoben

- Die freie Standard-Slotlänge wurde nach einem realen Testdruck von 68,8 auf
  73,2 mm erhöht. Gemessene Module von ungefähr 72,0 mm erhalten damit das
  unveränderte gesamte Längenspiel von 1,2 mm.
- Kalibrierkörper, Variantenkörper, abgeleitete Außenmaße und Regressionstests
  verwenden automatisch die korrigierte zentrale SO-DIMM-Länge.

### Geändert

- Das standardmäßige gesamte Dickenspiel wurde nach der realen
  Passungsprüfung von 1,0 auf 1,2 mm erhöht. Die freie Standard-Slotbreite
  beträgt damit 5,4 mm; die Vergleichsvarianten 0,8 / 1,0 / 1,2 mm bleiben
  erhalten.
- Der Kalibrierkörper und beide Grundkörper verwenden jetzt gemeinsame
  Matrixmaßfunktionen sowie dieselbe supportfreie Entnahmegeometrie.
- Projektdokumentation, Entwicklerkommentare, Diagnoseausgaben und
  CI-Bezeichnungen wurden auf Deutsch vereinheitlicht.
- Deutsch wurde als verbindliche Projektsprache für künftige Änderungen
  festgelegt.

## [0.2.0-slot-calibration] - 2026-07-31

### Hinzugefügt

- Initiales Repository und modulare OpenSCAD-Projektstruktur.
- Dokumentationsgrundlage für Konstruktionsentscheidungen, Validierung und
  zukünftige Arbeiten.
- Zentrale Nutzerkonfiguration für SO-DIMM-, Passungs-, Gehäuse-, Stapel-,
  Beschriftungs-, Drucker- und Debug-Parameter.
- Zentrale abgeleitete Maße ohne wiederholte Berechnungen auf Merkmalsebene.
- Parameter-Assertions mit verständlichen Fehlermeldungen.
- Konfigurierbare Prüfung des Druckerbauraums einschließlich der reservierten,
  nach unten ragenden Stapelfunktion.
- Über die Kommandozeile lesbare Konfigurationsdiagnose und meilensteinbezogene
  Bauraumvorschau.
- Supportfreie SO-DIMM-Slotausschnitte mit symmetrischen Einführfasen.
- Kompakter 2×2-Kalibrierkörper mit mittiger Entnahmefreistellung und Schonung
  der Kontaktkante.
- Optionale Toleranzvarianten mit 0,8, 1,0 und 1,2 mm sowie schriftunabhängigen
  gravierten Kennzeichnungen.
- Automatisierte OpenSCAD-Render-, Assertion-, STL-Topologie-, Maß-,
  Komponenten- und Variantenabstandsprüfungen.
- Reproduzierbarer Ein-Befehl-Export aller Kalibrier-STL-Dateien.
- Skalierbare Struktur für erzeugte Exporte mit ignorierten Netzdateien.
- Initialer GitHub-Actions-Workflow zum Erzeugen und Aufbewahren der
  STL-Artefakte.
- Versionierte Veröffentlichungshinweise für das Slot-Kalibrierungsrelease.

[Unveröffentlicht]: https://github.com/HacktoxX/sodimm-storage-box/compare/v0.2.0-slot-calibration...HEAD
[0.2.0-slot-calibration]: https://github.com/HacktoxX/sodimm-storage-box/releases/tag/v0.2.0-slot-calibration
