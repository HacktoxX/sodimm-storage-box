# Änderungsprotokoll

Alle wesentlichen Änderungen an diesem Projekt werden in dieser Datei
dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.1.0/).
Das Projekt beabsichtigt, der [semantischen Versionierung](https://semver.org/lang/de/)
zu folgen.

## [Unveröffentlicht]

### Geändert

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
