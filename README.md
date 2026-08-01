# Stapelbare SO-DIMM-Aufbewahrungsbox

Professionelle, parametrische und stapelbare Aufbewahrung für SO-DIMM-
Speichermodule, konstruiert in OpenSCAD für zuverlässigen FDM-3D-Druck.

> **Projektstatus:** Die Slotmaße sind physisch validiert. Ein vollständiger
> Grundkörper für 20 Module sowie ein verkürzter 2×3-Testkörper sind als
> Prototypen verfügbar. Die Stapelschnittstelle liegt als separates
> Kalibrierpaar mit vier Spielvarianten vor, ist aber noch nicht physisch
> validiert oder in den Grundkörper integriert. Das finale Labelsystem ist noch
> nicht implementiert.


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
`render_mode = "full_box"` den vollständigen 2×10-Grundkörper,
`render_mode = "full_box_short"` denselben Körper mit drei Reihen und
`render_mode = "stacking_test"` das Stapeltestpaar mit dem Standardspiel.
`render_mode = "stacking_test_variants"` ordnet vier gravierte
Spielvarianten druckfertig an. `render_mode = "debug"` erzeugt die Vorschau
des Maß- und Bauraums. Der Grundkörper ist noch keine finale stapelbare
Veröffentlichung.

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
| `exports/calibration/stacking-test.stl` | Unter- und Oberteil der Stapelkalibrierung mit 0,25 mm Gesamtspiel |
| `exports/calibration/stacking-test-variants.stl` | Vier gravierte Stapelpaare mit 0,20 / 0,25 / 0,30 / 0,35 mm Gesamtspiel |
| `exports/prototypes/sodimm-box-v3-body.stl` | Vollständiger Grundkörper mit 2 × 10 Slots |
| `exports/prototypes/sodimm-box-v3-short.stl` | Kurzer Grundkörper mit 2 × 3 Slots |

Eine manuelle Änderung an `config.scad` ist nicht erforderlich. Die
Rendermodi werden als OpenSCAD-Kommandozeilenparameter übergeben. Das Skript
erzeugt alle Dateien zunächst in einem temporären Verzeichnis und ersetzt die
Ausgabedateien erst, wenn sämtliche Renderdurchläufe erfolgreich waren.

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

Ein realer Testdruck mit ungefähr 72,0 mm langen Modulen hat gezeigt, dass die
ursprüngliche freie Slotlänge von 68,8 mm nicht ausreichte. Der zentrale Wert
`sodimm_length` beträgt deshalb jetzt 72,0 mm. Zusammen mit dem unveränderten
`slot_length_clearance` von 1,2 mm wird die freie Standard-Slotlänge
parametrisch als 73,2 mm berechnet. Kalibrier- und Grundkörper verwenden
dieselbe abgeleitete Maßkette.

Die reale Passungsprüfung hat außerdem die Variante mit 1,2 mm gesamtem
Dickenspiel als zuverlässig passend bestätigt. `slot_thickness_clearance`
beträgt deshalb standardmäßig 1,2 mm und ergibt zusammen mit der nominellen
Moduldicke von 4,2 mm eine freie Slotbreite von 5,4 mm beziehungsweise 0,6 mm
Spiel je Breitseite.

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

Die Slotlänge wurde nach dem ersten realen Testdruck von 68,8 auf 73,2 mm
korrigiert und anschließend mit den vorhandenen Modulen praktisch bestätigt.
Die Länge passt; aus den Breitenvarianten wurde 1,2 mm gesamtes Dickenspiel als
neuer Standard ausgewählt. Das Längenspiel wird zentral über `sodimm_length`
und `slot_length_clearance`, das Dickenspiel über `slot_thickness_clearance`
bestimmt; lokale Anpassungen am Kalibrierkörper sind nicht zulässig.

Für einen direkten Vergleich werden folgende Werte verwendet:

```scad
slot_test_variant_mode = true;
slot_test_clearance_variants = [0.8, 1.0, 1.2];
```

Die erzeugten Körper sind voneinander getrennt und mit `0.8`, `1.0` und `1.2`
graviert. Für die vorhandenen Module wurde bewusst `1.2` gewählt, da sich die
SO-DIMMs damit leichter einsetzen und entnehmen lassen. Standard- und
Varianten-STL werden gemeinsam mit `scripts/export_all.sh` erzeugt. Die
reproduzierbare Geometrieprüfung wird so gestartet:

```bash
scripts/validate_slot_test.sh
```

## Vollständiger Grundkörper

Meilenstein 3 erzeugt exakt 20 Slots in zwei Spalten und zehn Reihen. Jeder
Slot verwendet direkt dieselben Module für Einführfase, gerade Führung,
Endauflagen und Kontaktentlastung wie der physisch geprüfte Kalibrierkörper.
Die Positionen entstehen aus zwei parametrischen Schleifen; es existiert keine
zweite oder vereinfachte Slotimplementierung.

### Physisch validierte Standardwerte

| Prüfung | Ergebnis |
| --- | --- |
| Validiert auf | Bambu Lab P1S |
| Material | PETG |
| Freie Slotlänge | 73,2 mm |
| Gesamtes Dickenspiel | 1,2 mm |
| Freie Slotbreite | 5,4 mm |

Die größere Breitentoleranz wurde bewusst gewählt, weil sich die SO-DIMMs
damit komfortabler einsetzen und entnehmen lassen.

Der Grundkörper besitzt eine gerundete Außenkontur, einen geschlossenen Boden,
3,2-mm-Außenwände, 3,2-mm-Reihenstege, einen 8,0-mm-Mittelsteg und eine
durchgehende funktionale 45-Grad-Entnahmezone. Topoffene Randreliefs entfernen
Material nur außerhalb der tragenden Slotwände und reduzieren das Netzvolumen
gegenüber dem Körper ohne Reliefs um rund 16,3 %.

| Prototyp | Bounding Box | Netzvolumen |
| --- | ---: | ---: |
| 2×10-Grundkörper | 170,8 × 99,2 × 31,4 mm | 239.519 mm³ |
| 2×3-Kurztest | 170,8 × 39,0 × 31,4 mm | 95.488 mm³ |

Beide Prototypen sind supportfrei in der modellierten Ausrichtung vorgesehen.
Der Kurztest verwendet exakt dasselbe Körpermodul und reduziert ausschließlich
die Reihenzahl. Vor einem vollständigen Druck wird deshalb zunächst der kurze
Prototyp empfohlen.

Die reproduzierbare Vollkörperprüfung wird so gestartet:

```bash
scripts/validate_full_box.sh
```

Sie prüft Slotanzahl, Anordnung, Assertions, Außenmaße, Netzvolumen, genau eine
zusammenhängende Komponente, null nicht-manifold Kanten und den P1S-Bauraum.
Der komplette Grundkörper wurde noch nicht physisch gedruckt; seine Geometrie
ist rechnerisch sowie per OpenSCAD- und Meshprüfung validiert.

## Stapelkalibrierung

Die Stapelschnittstelle wird vor jeder Änderung am 20-Slot-Grundkörper mit
zwei kleinen Platten geprüft. Das Unterteil trägt den männlichen
Führungsrahmen und vier definierte Auflagen; das Oberteil enthält die passende
dachförmige Nut. Beide Teile verwenden direkt dieselben wiederverwendbaren
Module, die nach einem erfolgreichen Drucktest in den Vollkörper übernommen
werden können.

Die vier Rahmenseiten zentrieren in X und Y. Ihre 45-Grad-Flanken führen eine
seitlich versetzte Platte beim Absenken zur Mitte. Die weibliche Kontur endet
in einer 45-Grad-Dachkante und besitzt deshalb keine horizontale Blinddecke.
Clips, Snap-Fits und dünne Rastnasen werden nicht verwendet.

`stacking_clearance` bezeichnet das horizontale **Gesamtspiel** zwischen zwei
gegenüberliegenden Flanken. Der Standardwert 0,25 mm entspricht 0,125 mm je
Seite. Er ist noch kein physisch freigegebener Produktionswert. Für PETG wird
zuerst der Variantenkörper empfohlen:

```scad
render_mode = "stacking_test_variants";
stacking_clearance_variants = [0.20, 0.25, 0.30, 0.35];
```

Alternativ erzeugt `scripts/export_all.sh` beide Stapel-STLs ohne Änderung der
Konfigurationsdatei. Die normale Druckanordnung misst 70,0 × 58,0 × 4,8 mm,
das Variantenfeld 150,0 × 126,0 × 4,8 mm.

### Druck- und Passungsprüfung

1. Die STL unverändert in der konstruierten Orientierung laden. Unter- und
   Oberteil liegen bereits mit ihren supportfreien Druckseiten auf dem
   Druckbett; die Nut des Oberteils öffnet sich zur ersten Schicht.
2. Mit demselben P1S-PETG-Profil, 0,4-mm-Düse, 0,20-mm-Schichten und ohne
   Stützstrukturen drucken, das später für die Box vorgesehen ist.
3. Gleich markierte Teile zuordnen. Das Oberteil vom Druckbett lösen, mit der
   Nut nach unten auf die Feder setzen und nur mit leichtem Eigengewicht
   absenken. Nicht mit Kraft zusammendrücken.
4. Prüfen, ob die Flanken aus einer kleinen seitlichen Fehlstellung in beiden
   Achsen zentrieren, die vier Auflagen gleichmäßig anliegen, kein fühlbares
   Kippeln entsteht und sich das Oberteil ohne Verkeilen wieder abheben lässt.
5. Das kleinste Spiel wählen, das nach mehreren Stapel- und Trennzyklen sowie
   vollständig abgekühltem PETG zuverlässig funktioniert.

Die erste Schicht beeinflusst die nach unten offene Nut unmittelbar.
Elefantenfußkorrektur, Fluss und Betthaftung müssen deshalb dem späteren
Produktionsprofil entsprechen. Das Ergebnis des physischen Tests ist zu
dokumentieren, bevor eine Variante als Standard festgelegt oder die
Schnittstelle in den 20-Slot-Körper integriert wird.

Die reproduzierbare Geometrie- und Negativprüfung wird so gestartet:

```bash
scripts/validate_stacking_test.sh
```

## Zusammenbau und Stapeln

Jede Box soll später als ein Bauteil gedruckt werden und keinen Zusammenbau
erfordern. Die selbstzentrierende Stapelschnittstelle ist als separates
Kalibrierpaar konstruiert. Der aktuelle 20-Slot-Prototyp enthält absichtlich
noch keine Stapelgeometrie; die Integration folgt erst nach dem realen
PETG-Passungstest.

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
| `body.scad` | Vollständige Slotmatrix, gerundeter Grundkörper, Rippen und Materialreliefs |
| `slots.scad` | Parametrische Erzeugung der SO-DIMM-Slots |
| `stacking.scad` | Selbstzentrierende Stapelmechanik |
| `stacking_test.scad` | Separate Stapelkalibrierkörper und Spielvarianten |
| `label.scad` | Adaptive gravierte oder erhabene Beschriftung |
| `debug_preview.scad` | Meilensteinbezogene Maßausgabe und Bauraumvorschau |
| `slot_test.scad` | Vier-Slot-Passungstest und Toleranzvarianten |
| `render.scad` | Zentrale Auswahl des Rendermodus |
| `RAM_Box.scad` | Projekteinstiegspunkt, der nur Includes enthält |
| `tests/stacking_collision_check.scad` | 3D-Schnittsonde für kollisionsfreie Stapel-Sollpositionen |

## Lizenz

Lizenziert unter der [MIT-Lizenz](LICENSE). Der Lizenztext bleibt als
rechtsverbindlicher Standardtext in englischer Sprache erhalten.
