# Stapelbare SO-DIMM-Aufbewahrungsbox

Professionelle, parametrische und stapelbare Aufbewahrung für SO-DIMM-
Speichermodule, konstruiert in OpenSCAD für zuverlässigen FDM-3D-Druck.

> **Projektstatus:** Die Vier-Slot-Kalibriergeometrie ist für die reale
> Passungsprüfung bereit. Die Geometrie der finalen Box ist noch nicht
> veröffentlicht.

## Projektsprache

Deutsch ist die verbindliche Sprache für Dokumentation, Kommentare,
Diagnoseausgaben, Issues, Pull Requests und künftige Commit-Nachrichten.
Technische Bezeichner, etablierte Dateinamen, Kommandozeilenoptionen und
externe Schnittstellen bleiben unverändert, wenn eine Übersetzung die
Kompatibilität beeinträchtigen würde.

## Projektziele

- 20 SO-DIMM-Module in einer Anordnung aus zwei Spalten und zehn Reihen
  aufbewahren.
- Identische Boxen zur Aufbewahrung von 40 oder 60 Modulen kombinieren.
- Supportfrei auf einem Bambu Lab P1S mit PETG, einer 0,4-mm-Düse und einer
  Schichthöhe von 0,20 mm drucken.
- Eine selbstzentrierende, spielarme und leicht lösbare Stapelmechanik mit
  druckbaren 45-Grad-Flächen bereitstellen.
- Gleichmäßige Wandstärken, großzügige Radien, saubere Übergänge und eine
  verrippte Unterseite mit Taschen anstelle unnötiger Materialansammlungen
  verwenden.
- Alle funktionsrelevanten Maße konfigurierbar und frei von unerklärten
  Konstanten halten.

## Bilder

Validierte Renderbilder und Druckfotos werden nach den ersten Meilensteinen
für Geometrie und Druckprüfung unter `images/` ergänzt. Platzhalterbilder
werden nicht verwendet, da veröffentlichte Bilder ausschließlich geprüfte
Geometrie zeigen sollen.

## Vorgesehene Druckeinstellungen

| Einstellung | Vorgabe |
| --- | --- |
| Drucker | Bambu Lab P1S |
| Material | PETG |
| Düse | 0,4 mm |
| Schichthöhe | 0,20 mm |
| Stützstrukturen | Keine |
| AMS | Unterstützt, aber nicht erforderlich |

Die endgültigen Slicer-Einstellungen werden nach der realen Prüfung
dokumentiert.

## Manueller STL-Export

1. `src/RAM_Box.scad` in OpenSCAD öffnen.
2. Die gewünschten Werte in `src/config.scad` einstellen.
3. Das Modell mit **F6** rendern.
4. **Datei > Exportieren > Als STL exportieren** auswählen.

Der Einstiegspunkt enthält absichtlich ausschließlich Include-Anweisungen.
`render_mode = "slot_test"` erzeugt den druckbaren Kalibrierkörper,
`render_mode = "debug"` die Vorschau des Maß- und Bauraums. Keiner dieser
Modi entspricht bereits der finalen Aufbewahrungsbox mit 20 Slots.

## STL-Dateien erzeugen

Der vollständige veröffentlichte STL-Satz wird mit einem einzigen Befehl aus
dem Wurzelverzeichnis des Repositorys erzeugt:

```bash
scripts/export_all.sh
```

### Voraussetzungen

- Bash
- OpenSCAD mit ausführbarer Kommandozeilenanwendung

Das Skript sucht OpenSCAD in dieser Reihenfolge:

1. im explizit gesetzten Wert `SODIMM_OPENSCAD_BIN`,
2. als `openscad` im `PATH`,
3. unter `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`,
4. im versionierten macOS-Programmpaket 2021.01 älterer Installationen.

Bei einer abweichenden Installation kann der Pfad vorgegeben werden:

```bash
SODIMM_OPENSCAD_BIN=/absoluter/pfad/zu/openscad scripts/export_all.sh
```

### Erzeugte Dateien

| Ausgabe | Inhalt |
| --- | --- |
| `exports/calibration/sodimm-slot-test.stl` | Standard-Kalibrierkörper mit 2 × 2 Slots |
| `exports/calibration/sodimm-slot-variants.stl` | Gravierte Varianten mit 0,8, 1,0 und 1,2 mm Spiel |

Eine manuelle Änderung an `config.scad` ist nicht erforderlich. Die
Rendermodi werden als OpenSCAD-Kommandozeilenparameter übergeben. Das Skript
erzeugt beide Dateien zunächst in einem temporären Verzeichnis und ersetzt
die Ausgabedateien erst, wenn beide Renderdurchläufe erfolgreich waren.

Ein fehlendes Programm, eine OpenSCAD-Warnung oder ein OpenSCAD-Fehler, eine
fehlgeschlagene Assertion oder eine leere Ausgabe führt zu einer verständlichen
Meldung und einem von null verschiedenen Exit-Code. Erzeugte STL-Dateien
bleiben von Git ignoriert, können aber direkt als Assets eines GitHub-Releases
hochgeladen werden.

Der vorbereitete GitHub-Actions-Workflow führt denselben Export unter Ubuntu
24.04 aus und speichert die erzeugten Dateien als herunterladbares
Workflow-Artefakt. Das automatische Anhängen an GitHub-Releases ist für einen
späteren Meilenstein vorgesehen.

## Parameter

Die nutzerseitigen Parameter liegen in `src/config.scad`. Die anfängliche
Konfiguration enthält die erforderlichen SO-DIMM-Abmessungen, die Anordnung,
den Druckprozess, das Spiel der Stapelmechanik und die Beschriftungsoptionen.
Abgeleitete Werte und ihre Assertions befinden sich in `src/dimensions.scad`,
damit Implementierungsdateien weder magische Zahlen noch wiederholte
Berechnungen enthalten.

Für eine reguläre Änderung der Beschriftung muss später nur dieser Wert
angepasst werden:

```scad
label_text = "PC4-3200";
```

## Kalibrierungstest

Vor einer vollständigen Box mit 20 Slots sollte der Vier-Slot-Kalibrierkörper
gedruckt werden. Mit deutlich weniger Material prüft er die reale Moduldicke,
die PETG-Oberfläche, das Maßverhalten des Druckers, das Einsteckgefühl und die
Entnahme.

So wird der normale 2×2-Test manuell in OpenSCAD erzeugt:

1. `render_mode = "slot_test"` einstellen.
2. `slot_test_variant_mode = false` einstellen.
3. `src/RAM_Box.scad` mit **F6** rendern und als STL exportieren.
4. Das Modell wie konstruiert aufrecht, mit dem vorgesehenen PETG-Profil und
   ohne Stützstrukturen drucken.

Ein stromloses SO-DIMM senkrecht mit der Kontaktkante zum geschützten Slotboden
einsetzen. Die Platine nur an ihren Kanten anfassen und niemals mit Gewalt
einführen. Bei einer guten Passung gleitet das Modul ohne Haken durch die
Einführfase, erreicht beide Endauflagen, wird nicht durchgebogen oder seitlich
geklemmt, hat wenig Spiel und lässt sich über die mittige Freistellung
entnehmen.

Die dicksten Module prüfen, die später aufbewahrt werden sollen. Ist die
Passung zu eng oder zu locker, wird `slot_thickness_clearance` angepasst. Der
Wert beschreibt den gesamten Zuschlag zur nominellen Moduldicke, nicht das
Spiel pro Seite.

Für einen direkten Vergleich werden folgende Werte verwendet:

```scad
slot_test_variant_mode = true;
slot_test_clearance_variants = [0.8, 1.0, 1.2];
```

Die erzeugten Körper sind voneinander getrennt und mit `0.8`, `1.0` und `1.2`
graviert. Zu verwenden ist der kleinste Wert, mit dem sich ein Modul zuverlässig
einsetzen und entnehmen lässt, ohne es zu belasten. Standard- und Varianten-STL
werden gemeinsam mit `scripts/export_all.sh` erzeugt. Die reproduzierbare
Geometrieprüfung wird so gestartet:

```bash
scripts/validate_slot_test.sh
```

## Zusammenbau und Stapeln

Jede Box soll später als ein Bauteil gedruckt werden und keinen Zusammenbau
erfordern. Mehrere Boxen werden durch die integrierte selbstzentrierende
Schnittstelle ausgerichtet. Ausführliche Hinweise zum Stapeln und Trennen
folgen nach der Prüfung der Toleranzkörper und vollständiger Testdrucke.

## Anpassungen

Die Architektur trennt Nutzerkonfiguration, abgeleitete Maße, wiederverwendbare
Hilfsmodule, Körpergeometrie, Slots, Stapelmechanik und Beschriftung. Varianten
können dadurch geprüfte Geometrie wiederverwenden, ohne das vollständige Modell
zu kopieren.

Die Konstruktionsentscheidungen stehen in [DESIGN.md](docs/DESIGN.md), die
geplanten Meilensteine in [ROADMAP.md](docs/ROADMAP.md).

## Quellstruktur

| Datei | Zuständigkeit |
| --- | --- |
| `config.scad` | Nutzerparameter und Fertigungsvorgaben |
| `helpers.scad` | Wiederverwendbare Geometrie- und Prüfungshilfen |
| `dimensions.scad` | Abgeleitete Maße und Maß-Assertions |
| `body.scad` | Hülle, Unterseitentaschen, Rippen und Griffmulde |
| `slots.scad` | Parametrische Erzeugung der SO-DIMM-Slots |
| `stacking.scad` | Selbstzentrierende Stapelmechanik |
| `label.scad` | Adaptive gravierte oder erhabene Beschriftung |
| `debug_preview.scad` | Meilensteinbezogene Maßausgabe und Bauraumvorschau |
| `slot_test.scad` | Vier-Slot-Passungstest und Toleranzvarianten |
| `render.scad` | Zentrale Auswahl des Rendermodus |
| `RAM_Box.scad` | Projekteinstiegspunkt, der nur Includes enthält |

## Lizenz

Lizenziert unter der [MIT-Lizenz](LICENSE). Der Lizenztext bleibt als
rechtsverbindlicher Standardtext in englischer Sprache erhalten.
