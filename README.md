# Stapelbare SO-DIMM-Aufbewahrungsbox

Professionelle, parametrische und stapelbare Aufbewahrung für SO-DIMM-
Speichermodule, konstruiert in OpenSCAD für zuverlässigen FDM-3D-Druck.

> **Projektstatus:** Die offene, stapelbare 20-Slot-Box ist als finales
> Produktionsmodell abgeschlossen. Slotlänge, Dickenspiel und das horizontale
> Stapelspiel wurden mit PETG auf einem Bambu Lab P1S physisch kalibriert. Die
> finale STL wird reproduzierbar erzeugt und automatisiert als Einzelbox sowie
> im Zweierstapel geometrisch geprüft. Ein variables frontseitiges
> Beschriftungsfeld ist integriert. Deckel, Clips, Magnete und weiteres Zubehör
> sind bewusst nicht Bestandteil dieser Ausführung.


## Projektziele

- 20 SO-DIMM-Module in einer Anordnung aus zwei Spalten und zehn Reihen
  aufbewahren.
- Identische Boxen zur Aufbewahrung von 40 oder 60 Modulen kombinieren.
- Supportfrei auf einem Bambu Lab P1S mit PETG, einer 0,4-mm-Düse und einer
  Schichthöhe von 0,20 mm drucken.
- Eine selbstzentrierende, spielarme und leicht lösbare Stapelmechanik mit
  druckbaren 45-Grad-Flächen bereitstellen.
- Ein automatisch skaliertes Beschriftungsfeld mit gravierter oder geschützt
  erhabener Ausgabe bereitstellen.
- Gleichmäßige Wandstärken, großzügige Radien, saubere Übergänge und
  topoffene Materialreliefs anstelle unnötiger Materialansammlungen verwenden.
- Alle funktionsrelevanten Maße konfigurierbar und frei von unerklärten
  Konstanten halten.

## Bilder

Validierte Renderbilder und Druckfotos werden nach den ersten Meilensteinen
für Geometrie und Druckprüfung unter `images/` ergänzt. Platzhalterbilder
werden nicht verwendet, da veröffentlichte Bilder ausschließlich geprüfte
Geometrie zeigen sollen.

## Druckeinstellungen

| Einstellung | Vorgabe |
| --- | --- |
| Drucker | Bambu Lab P1S |
| Material | PETG |
| Düse | 0,4 mm |
| Schichthöhe | 0,20 mm |
| Stützstrukturen | Keine |
| AMS | Unterstützt, aber nicht erforderlich |
| Druckausrichtung | Unverändert, Nutseite plan auf dem Druckbett |

Ein kalibriertes PETG-Profil für den eigenen Drucker ist wichtiger als ein
pauschaler Flusswert. Besonders erste Schicht, Elefantenfußkorrektur und
Bauteilkühlung beeinflussen die nach unten offene Stapelnut. Für die große
Grundfläche kann bei bekannter Warping-Neigung ein Brim verwendet werden; an
der Modellgeometrie sind keine Stützstrukturen erforderlich. Eine Druckzeit
wird nicht angegeben, da die finale STL in diesem Projekt nicht mit einem
verbindlichen Bambu-Studio-Profil gesliced wurde.

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
des Maß- und Bauraums. `render_mode = "final_box"` erzeugt die offene,
vollständig stapelbare Produktionsbox.

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
| `exports/final/sodimm-storage-box-final.stl` | Finale offene 20-Slot-Box mit integrierter Stapelmechanik |

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
Workflow-Artefakt. Ein automatisches Veröffentlichen als GitHub-Release ist
bewusst nicht Teil des abgeschlossenen Projektumfangs.

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

Für die normale Anpassung genügt eine einzige Zeile:

```scad
label_text = "PC4-3200";
```

Das 58 × 11 mm große Feld sitzt mittig auf der Vorderseite. Die Schrift wird
horizontal und vertikal zentriert und bei längeren Texten automatisch auf die
verfügbare Fläche verkleinert. `label_mode = "engraved"` erzeugt die
Standardgravur; `label_mode = "raised"` erzeugt einen geschützten erhabenen
Text innerhalb desselben vertieften Felds. Beide Modi behalten die gleichen
Außenmaße und benötigen kein AMS.

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

Die Stapelschnittstelle wurde vor der Integration in den 20-Slot-Grundkörper
mit zwei kleinen Platten geprüft. Das Unterteil trägt den männlichen
Führungsrahmen und vier definierte Auflagen; das Oberteil enthält die passende
dachförmige Nut. Beide Teile verwenden direkt dieselben wiederverwendbaren
Module, die unverändert auch die finale Box erzeugen.

Die vier Rahmenseiten zentrieren in X und Y. Ihre 45-Grad-Flanken führen eine
seitlich versetzte Platte beim Absenken zur Mitte. Die weibliche Kontur endet
in einer 45-Grad-Dachkante und besitzt deshalb keine horizontale Blinddecke.
Clips, Snap-Fits und dünne Rastnasen werden nicht verwendet.

`stacking_clearance` bezeichnet das horizontale **Gesamtspiel** zwischen zwei
gegenüberliegenden Flanken. Der Standardwert 0,25 mm entspricht 0,125 mm je
Seite. Dieser Wert wurde mit PETG auf dem Bambu Lab P1S physisch ausgewählt und
ist der freigegebene Produktionsstandard. Bei einem anderen Drucker, Material
oder stark abweichender erster Schicht wird weiterhin zuerst der
Variantenkörper empfohlen:

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
   vollständig abgekühltem PETG zuverlässig funktioniert. Für die validierte
   P1S-/PETG-Kombination ist dies 0,25 mm Gesamtspiel.

Die erste Schicht beeinflusst die nach unten offene Nut unmittelbar.
Elefantenfußkorrektur, Fluss und Betthaftung müssen deshalb dem späteren
Produktionsprofil entsprechen.

Die reproduzierbare Geometrie- und Negativprüfung wird so gestartet:

```bash
scripts/validate_stacking_test.sh
```

## Zusammenbau und Stapeln

Jede Box wird als ein einziges Bauteil gedruckt und benötigt keinen
Zusammenbau. Die SO-DIMMs senkrecht und ohne Kraft in die Slots einsetzen. Zum
Stapeln zwei identische Boxen grob übereinander ausrichten und die obere Box
senkrecht absenken. Die vier 45-Grad-Flanken zentrieren in X und Y; vier
Auflagen begrenzen die Eingriffstiefe. Zum Trennen gleichmäßig senkrecht
anheben und nicht verkanten.

## Finale Produktionsbox

Die finale Box kombiniert exakt 20 kalibrierte Slots mit dem physisch
bestätigten Stapelspiel von 0,25 mm. Ein eigener, aus den Merkmalabmessungen
berechneter Funktionsrand trennt Stapelrahmen, Slotfasen, Entnahmezone und
Materialreliefs. Die Entnahmefreistellung bleibt über das gesamte Slotfeld
zugänglich, endet aber vor den tragenden vorderen und hinteren
Stapelrahmensegmenten. Ein gefastes Beschriftungsfeld hält die Frontfläche im
Labelbereich geschlossen und schützt Gravur oder Relief vor Beschädigung.

| Merkmal | Ergebnis |
| --- | ---: |
| Außenmaß einschließlich Feder | 176,8 × 105,2 × 33,6 mm |
| Grundkörper | 176,8 × 105,2 × 31,4 mm |
| Zweierstapel | 176,8 × 105,2 × 66,2 mm |
| Stapelrahmen-Mittellinie | 163,35 × 91,75 mm |
| Beschriftungsfeld | 58,0 × 11,0 mm |
| Standardtext / Schriftgröße | PC4-3200 / 6,0 mm |
| Netzvolumen mit Gravur | 336.597 mm³ |
| Mesh mit Gravur | 9.716 Dreiecke, 1 Komponente, 0 Nicht-Manifold-Kanten |

Die finale Prüfung rendert Gravur und Relief jeweils als vollständige
manifold Einzelbox. Zusätzlich werden ein längerer Beispieltext zur Prüfung
der automatischen Skalierung sowie zwei vollständige Boxen in Sollposition
erzeugt. Der Zweierstapel besitzt zwei getrennte manifold Komponenten; eine
separate Schnittsonde bestätigt, dass zwischen ihnen kein überschneidendes
Volumen existiert. Die Prüfung wird reproduzierbar gestartet mit:

```bash
scripts/validate_final_box.sh
```

Die integrierte Gesamtgeometrie wurde rechnerisch, mit OpenSCAD und als Mesh
geprüft. Die Slot- und Stapelpassungen beruhen auf realen P1S-/PETG-
Kalibrierungen. Ein vollständiger Produktionsdruck der final integrierten Box
wurde in diesem Entwicklungslauf nicht gesliced oder zeitlich bewertet.

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
| `final_box.scad` | Finale 20-Slot-Box mit integrierter Nut, Feder und Auflagen |
| `label.scad` | Adaptive gravierte oder erhabene Beschriftung |
| `debug_preview.scad` | Meilensteinbezogene Maßausgabe und Bauraumvorschau |
| `slot_test.scad` | Vier-Slot-Passungstest und Toleranzvarianten |
| `render.scad` | Zentrale Auswahl des Rendermodus |
| `RAM_Box.scad` | Projekteinstiegspunkt, der nur Includes enthält |
| `tests/stacking_collision_check.scad` | 3D-Schnittsonde für kollisionsfreie Stapel-Sollpositionen |
| `tests/final_stack_collision_check.scad` | Kollisionssonde zweier vollständiger Boxen |
| `tests/final_two_box_stack.scad` | Zwei vollständige Boxen in realer Stapellage |

## Lizenz

Lizenziert unter der [MIT-Lizenz](LICENSE). Der Lizenztext bleibt als
rechtsverbindlicher Standardtext in englischer Sprache erhalten.
