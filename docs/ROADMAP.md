# Roadmap

Das Projekt wird in kleinen, unabhängig prüfbaren Meilensteinen entwickelt.
Ein Meilenstein gilt erst als abgeschlossen, wenn Dokumentation und angemessene
Validierung im selben Entwicklungsschritt enthalten sind.

## Kernkonstruktion

- [x] Repository und modulare Quellarchitektur anlegen.
- [x] Abgeleitete Maße, Parameterprüfung und Assertions für den P1S-Bauraum
  definieren.
- [x] Wiederverwendbare Hilfsmodule für gerundete Hüllen und Übergänge
  entwickeln.
- [x] Vier-Slot-Passungstest für SO-DIMMs entwickeln.
- [x] Testkörper mit den dicksten verfügbaren SO-DIMMs drucken und prüfen.
- [x] Den validierten Slot auf die 2×10-Matrix erweitern.
- [x] Tragenden Grundkörper mit gerundeter Kontur, Randreliefs und Rippen
  entwickeln.
- [x] 2×3-Kurztest aus derselben vollständigen Körpergeometrie bereitstellen.
- [ ] Grundkörper und Kurztest physisch mit PETG drucken und prüfen.
- [ ] Unterseite nach realer Steifigkeitsprüfung weiter optimieren.
- [ ] Mittige Griffmulde entwickeln und ergonomisch prüfen.
- [x] Toleranzkörper für die Stapelmechanik entwickeln.
- [x] Vier gravierte Gesamtspielvarianten von 0,20 bis 0,35 mm bereitstellen
  und rechnerisch sowie als Mesh validieren.
- [ ] Stapelkalibrierkörper mit dem vorgesehenen P1S-PETG-Profil drucken.
- [ ] Selbstzentrierung, Kippfreiheit und Lösbarkeit über mehrere Zyklen
  physisch prüfen und das ausgewählte Gesamtspiel dokumentieren.
- [ ] Selbstzentrierende Stapelmechanik mit 45-Grad-Flächen integrieren.
- [ ] Konkrete Vollkörperposition gegen Slots, Kontaktentlastungen,
  Randreliefs und Entnahmezone mit Keep-out-Assertions absichern.
- [ ] Adaptive gravierte und erhabene Beschriftung ergänzen.
- [ ] Vollständige Box auf einem Bambu Lab P1S mit PETG drucken und prüfen.
- [ ] Geprüfte Renderbilder, Druckfotos, STL-Dateien und MakerWorld-
  Dokumentation veröffentlichen.

## Build- und Release-Automatisierung

- [x] Reproduzierbaren Ein-Befehl-Export der STL-Dateien bereitstellen.
- [x] GitHub-Actions-Workflow für den STL-Build ergänzen.
- [x] Stapelkalibrierung im lokalen und CI-basierten STL-Build prüfen und
  exportieren.
- [ ] Erzeugte STL-Artefakte automatisch an getaggte Releases anhängen.
- [ ] Prüfsummen und Herkunftsmetadaten für Releases ergänzen.

## Zukünftige Varianten

- [ ] Optionaler Deckel.
- [ ] Gridfinity-Adapter.
- [ ] Magnetaufnahmen.
- [ ] Wandhalterung.
- [ ] Version für DIMMs voller Baugröße.
- [ ] Version für M.2-SSDs.
