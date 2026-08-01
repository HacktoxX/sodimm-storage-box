# Erzeugte Exporte

Dieses Verzeichnis bildet die stabile Ausgabestruktur für reproduzierbare
OpenSCAD-Exporte. Erzeugte Netzdateien werden absichtlich nicht in Git
aufgenommen und mit folgendem Befehl erstellt:

```bash
scripts/export_all.sh
```

Aktuelle und reservierte Kategorien:

- `calibration/` — Passungstestkörper und Toleranzvarianten
- `final/` — zukünftige validierte Produktionsmodelle
- `prototypes/` — vollständiger 2×10-Grundkörper und 2×3-Kurztest für die Entwicklung
- `examples/` — zukünftige Beispielkonfigurationen

Die repositoryweite Regel `*.stl` hält erzeugte Modelle aus regulären Commits
heraus. Verantwortliche können eine Datei bei Bedarf bewusst mit `git add -f`
aufnehmen; Assets für GitHub-Releases sollten normalerweise direkt aus dieser
Ausgabestruktur hochgeladen werden.
