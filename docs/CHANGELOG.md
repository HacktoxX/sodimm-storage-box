# Änderungsprotokoll

Alle wesentlichen Änderungen an diesem Projekt werden in dieser Datei
dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.1.0/).
Das Projekt beabsichtigt, der [semantischen Versionierung](https://semver.org/lang/de/)
zu folgen.

## [Unveröffentlicht]

### Hinzugefügt

- Finaler Rendermodus `final_box` für die offene, einteilige und stapelbare
  20-Slot-Produktionsbox.
- Aus der Stapelkontur abgeleiteter 8,0-mm-Funktionsrand mit konkreten
  Keep-out-Assertions gegen Slotfasen, Entnahmezone und Materialreliefs.
- Vollständig integrierter männlicher 45-Grad-Führungsrahmen, supportfreie
  dachförmige Nut und vier definierte Stapelauflagen.
- Reproduzierbarer Export
  `exports/final/sodimm-storage-box-final.stl`.
- Automatisierte Prüfung der finalen Einzelbox auf 20 Slots, Maßkette,
  P1S-Bauraum, Bounding Box, Netzvolumen, genau eine Komponente und null
  Nicht-Manifold-Kanten.
- Reales Zwei-Boxen-Prüfmodell sowie volumetrische Kollisionssonde für die
  Soll-Stapellage.
- CI-Prüfung und Workflow-Artefakt für die finale STL.
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
- Parametrische männliche und weibliche Stapelkonturen aus demselben
  Parametersatz mit 45-Grad-Flanken und dachförmig supportfreier Nut.
- Kompaktes Stapelkalibrierpaar mit definierten Auflageländern,
  selbstzentrierender Führung in X und Y und schriftunabhängiger Gravur.
- Vier getrennt druckbare Stapelspielvarianten mit 0,20 / 0,25 / 0,30 /
  0,35 mm horizontalem Gesamtspiel.
- Rendermodi `stacking_test` und `stacking_test_variants` ohne Geometrie im
  Dispatcher oder Integration in den 20-Slot-Grundkörper.
- Reproduzierbare Exporte `stacking-test.stl` und
  `stacking-test-variants.stl`.
- Automatisierte Stapelprüfung für Gesamt- und Seitenspiel, 45-Grad-Grenze,
  Führungstiefe, Zentrierweg, Featurestärke, Rückwand, Außenkantenabstand,
  P1S-Bauraum, Bounding Box, Netzvolumen, Komponenten, Manifold-Topologie und
  ein leeres 3D-Schnittvolumen in Sollposition.
- Gemeinsame schriftunabhängige Siebensegment-Ziffern für Slot- und
  Stapelkalibrierungen.

### Behoben

- Die dachförmigen Nutsegmente decken jetzt auch die vollständige Länge der
  Federbasis an allen vier Rahmenecken ab. Eine separate 3D-Schnittprüfung
  verhindert erneute Eckkollisionen für sämtliche Spielvarianten.
- Die freie Standard-Slotlänge wurde nach einem realen Testdruck von 68,8 auf
  73,2 mm erhöht. Gemessene Module von ungefähr 72,0 mm erhalten damit das
  unveränderte gesamte Längenspiel von 1,2 mm.
- Kalibrierkörper, Variantenkörper, abgeleitete Außenmaße und Regressionstests
  verwenden automatisch die korrigierte zentrale SO-DIMM-Länge.

### Geändert

- Das mit PETG auf dem Bambu Lab P1S geprüfte Stapelgesamtspiel von 0,25 mm
  ist jetzt als physisch validierter Produktionsstandard dokumentiert und in
  die finale Box übernommen.
- Die Entnahmezone endet im finalen Modell vor dem vorderen und hinteren
  Stapelrahmen, bleibt über dem vollständigen Slotfeld jedoch zugänglich.
- Die finalen topoffenen Materialreliefs werden aus dem verbleibenden
  Querschnitt unter der Stapelfeder berechnet; mindestens 2,4 mm tragendes
  Material bleibt erhalten.
- Der Projektumfang ist als abgeschlossen dokumentiert. Deckel,
  Beschriftungsgeometrie, Clips, Magnete und Zubehör gehören bewusst nicht zur
  finalen Box.
- Das standardmäßige gesamte Dickenspiel wurde nach der realen
  Passungsprüfung von 1,0 auf 1,2 mm erhöht. Die freie Standard-Slotbreite
  beträgt damit 5,4 mm; die Vergleichsvarianten 0,8 / 1,0 / 1,2 mm bleiben
  erhalten.
- Der Kalibrierkörper und beide Grundkörper verwenden jetzt gemeinsame
  Matrixmaßfunktionen sowie dieselbe supportfreie Entnahmegeometrie.
- `stacking_clearance` ist eindeutig als horizontales Gesamtspiel definiert;
  die Standardkontur verteilt 0,25 mm symmetrisch als 0,125 mm je Flanke.
- Die konservativ reservierte Gesamthöhe berücksichtigt jetzt die 2,2 mm hohe
  Stapelkalibrierkontur und beträgt 33,6 mm. Die reale Grundkörpergeometrie
  bleibt unverändert 31,4 mm hoch.
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
