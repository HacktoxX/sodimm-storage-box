# Konstruktionsentscheidungen

## Status

Dieses Dokument unterscheidet zwischen berechneten Konstruktionsentscheidungen
und durch Druckversuche bestätigten Ergebnissen. Das Maßsystem und die
Assertions sind implementiert und über die Kommandozeile geprüft. Passungswerte
bleiben Prüfziele, bis repräsentative PETG-Testkörper mit realen SO-DIMMs
gedruckt wurden.

## Konstruktionsvorgaben

| Vorgabe | Anfangswert | Zweck |
| --- | ---: | --- |
| SO-DIMM-Platinenlänge | 67,6 mm | Definiert den Bauraum des Moduls |
| SO-DIMM-Platinenhöhe | 30,0 mm | Definiert Einstecktiefe und Auflagebereich |
| SO-DIMM-Gesamtdicke | 4,2 mm | Konservative Standardhülle der Komponenten |
| Kapazität | 20 Module | Geforderte Kapazität der Box |
| Anordnung | 2 Spalten × 10 Reihen | Geforderte Organisation |
| Spiel der Stapelschnittstelle | 0,25 mm | Unteres Ende des PETG-Prüfbereichs |
| Maximaler beabsichtigter Überhang | 45° | Vorgabe für supportfreien Druck |
| Druckerbauraum | 256 × 256 × 256 mm | Bauraum des Bambu Lab P1S |

Alle geometriewirksamen Werte müssen konfigurierbar bleiben. Nominelle
Bauteilmaße, Fertigungsspiel und abgeleitete Geometrie werden getrennt gehalten,
damit eine Druckeranpassung die SO-DIMM-Referenzmaße nicht unbemerkt verändert.

Die Hülle von 67,6 × 30,0 × 4,2 mm ist eine technische Vorgabe und keine
Behauptung, dass jedes gefertigte Modul dieselbe Komponentenstärke besitzt.
Heatspreader, ungewöhnlich hohe Bauteile, Aufkleber und Platinenabweichungen
können den Standardwert überschreiten. Der Passungstest muss deshalb mit den
dicksten Modulen erfolgen, die tatsächlich aufbewahrt werden sollen.

## Architektur

Das Modell ist nach Zuständigkeiten getrennt. `config.scad` bildet die
öffentliche Parameteroberfläche, `dimensions.scad` verwaltet abgeleitete Werte
und Assertions, und jede Geometriedatei besitzt genau eine Merkmalsfamilie.
`RAM_Box.scad` enthält ausschließlich Includes. Änderungen bleiben dadurch gut
prüfbar und künftige Varianten können dieselben validierten Module verwenden.

## Parameterhoheit und abgeleitete Maße

`config.scad` enthält ausschließlich Werte, die ein Nutzer sinnvoll ändern
kann: Hardwarehülle, Spiele, Anordnung, Gehäusevorgaben, Beschriftung,
Druckergrenzen und Debug-Modus. Berechnete Werte und Geometrie gehören nicht in
diese Datei.

`dimensions.scad` überführt diese Eingaben in eine einzige verbindliche
Maßkette. Die Standardkonfiguration ergibt:

| Abgeleiteter Wert | Ergebnis |
| --- | ---: |
| Slotabmessung | 68,8 × 5,2 mm |
| Slotfeld | 145,6 × 80,8 mm |
| Hauptkörper | 162,0 × 97,2 × 31,4 mm |
| Gesamter Druckbauraum | 162,0 × 97,2 × 33,0 mm |
| Freiliegende SO-DIMM-Höhe | 1,0 mm |

Die Gesamthöhe enthält die reservierte, 1,6 mm nach unten ragende
Stapelfunktion. Der geplante Stapelsteg bleibt innerhalb der X-/Y-Grundfläche
des Körpers. Jedes spätere Merkmal, das weiter nach außen reicht, muss die
zentrale Bauraumberechnung aktualisieren, statt die Bauraum-Assertions zu
umgehen.

## Passungsspiele

Der anfängliche Slot addiert 1,2 mm zur nominellen Modullänge und 1,0 mm zur
nominellen Gesamtdicke. Zentriert entsprechen diese Werte 0,6 mm an jedem Ende
und 0,5 mm an jeder Breitseite. Die bewusst konservative Ausgangsbasis
berücksichtigt PETG-Oberflächenstruktur, Elefantenfuß, Druckerabweichungen und
Unterschiede zwischen SO-DIMM-Bauformen. Einführfasen und gerundete Auflagen
bestimmen das tatsächliche Gefühl; die Zahlenwerte müssen vor Freigabe des
20-Slot-Feldes mit dem Vier-Slot-Testkörper bestätigt werden.

Das Spiel der Stapelmechanik beginnt mit 0,25 mm am engeren Ende des geforderten
Bereichs von 0,25 bis 0,30 mm. Es gilt erst als validiert, wenn wiederholte
Stapel- und Trennversuche sowohl geringes Spiel als auch leichtes Lösen zeigen.

## Vier-Slot-Kalibriergeometrie

Der Kalibrierkörper bildet zwei Spalten und zwei Reihen mit derselben
`slot_length`, demselben Mittelabstand, Reihenabstand, derselben Bodenstärke,
Einstecktiefe und Mindestwandstärke wie die geplante vollständige Box ab. Der
einzelne Standardkörper misst 152,0 × 20,0 × 31,4 mm. Werden die vier
Slotvolumen von einem kompakten Grundkörper abgezogen, bleiben nur der
geschlossene Boden, Außenwände, Mittelsteg und Reihentrenner zurück; ein
funktionsloser massiver Kern entsteht nicht.

Jeder Slot besitzt innerhalb der 29,0 mm Einstecktiefe eine 27,8 mm lange
gerade Führung und einen 1,2 mm hohen Einführbereich. Die Öffnung erweitert sich
an allen vier Seiten um 0,8 mm. Da die horizontale Erweiterung kleiner als die
vertikale Höhe ist, bleiben alle Fasen innerhalb der supportfrei druckbaren
45-Grad-Grenze. Zwischen den erweiterten Öffnungen verbleiben 6,4 mm zwischen
den Spalten, 1,6 mm zwischen den Reihen und 2,4 mm am Außenrand. Alle Werte
bleiben positiv und werden vor der Geometrieauswertung geprüft.

Die funktionale Entnahmeöffnung ist absichtlich noch nicht die finale
ergonomische Griffmulde. Sie beginnt am 8,0 mm breiten Mittelabstand und weitet
sich über dem Testkörper mit 45 Grad nach oben. Ihre Tiefe von 8,0 mm lässt vom
Druckbett aus einen 23,4 mm hohen Mittelsteg stehen und liegt damit deutlich
über dem geforderten tragenden Bereich von 3,2 mm.

## Schutz der Kontaktkante

Am Boden jedes Slots bleiben zwei flache, jeweils 5,0 mm lange Endauflagen
stehen. Dazwischen wird eine 58,8 mm lange Freistellung um 0,8 mm vertieft. Das
Modul liegt dadurch an den äußeren Platinenenden auf, während der größte Teil
der Kontaktkante über dem Boden frei bleibt. Seitliche Noppen oder Clips ragen
nicht in den Slot, sodass weder Komponenten noch Kontakte seitlich geklemmt
werden. Unter der Freistellung verbleiben 1,6 mm beziehungsweise acht
Zielschichten.

SO-DIMM-Kontaktanordnungen unterscheiden sich. Vor Übernahme dieser Lösung in
die vollständige Box muss visuell geprüft werden, ob die Endauflagen auf
unbedenklichen Platinenbereichen der realen Module liegen. Ein Modul, dessen
Kontakte oder Komponenten eine Auflage berühren, darf nicht mit Kraft
eingesetzt werden.

## Kalibriertoleranzen

Der normale Körper verwendet das gemeinsame Dickenspiel von 1,0 mm. Im
Variantenmodus werden Körper mit 0,8, 1,0 und 1,2 mm sowie einer numerischen
Gravur an der Vorderseite erzeugt. Die Werte sind Gesamtzuschläge zur
nominellen Moduldicke von 4,2 mm und ergeben Slotbreiten von 5,0, 5,2 und
5,4 mm. Die Anordnung richtet sich nach der breitesten konfigurierten Variante,
hält mindestens den eingestellten Abstand von 12,0 mm ein und verhindert eine
unbeabsichtigte Berührung der Netze.

Berechnete Spiele können PETG-Fluss, Abkühlung, Elefantenfuß,
Oberflächenstruktur oder das dickste bestückte Modul nicht vorhersagen. Vor der
Konstruktion der vollständigen Slotmatrix ist deshalb ein realer Testkörper
mit dem Zieldrucker, dem vorgesehenen Material, der Schichthöhe und echten
Modulen erforderlich.

## Wand- und Bodenstärke

Die 3,2-mm-Wand entspricht acht nominellen Düsendurchmessern von 0,4 mm. Sie
bildet eine steife Ausgangsbasis für das hohe Slotfeld und bietet genügend
Querschnitt für gerundete Übergänge und die spätere Stapelaufnahme. Da die
tatsächliche Extrusionsbreite des Slicers vom Düsendurchmesser abweichen kann,
muss die Erzeugung der Wandlinien trotzdem geprüft werden.

Der 2,4-mm-Boden entspricht zwölf Schichten mit 0,20 mm Höhe. Er bildet eine
durchgehende tragende Haut und lässt zugleich ausreichend Tiefe für spätere
Unterseitentaschen und Rippen. Lokale Verstärkungen werden mit Rippen und
weichen Übergängen statt mit verborgenen massiven Blöcken ausgeführt.

## Slotgeometrie

Jeder Slot wird als wiederverwendbarer Generator mit Einführfase, gerundeten
Innenübergängen, kontrolliertem Passungsspiel und ergonomischem Zugriff für
Finger oder Daumen entwickelt. Vor der Freigabe des vollständigen Feldes wird
ein Vier-Slot-Testkörper mit beiden Spalten und zwei Reihen gedruckt.

## Stapelmechanik

Das Stapelsystem wird als eigenständiges funktionales Teilsystem behandelt.
Die geplante Schnittstelle verwendet durchgehende konische Führungsflächen
anstelle rechteckiger Füße. Gegenüberliegende 45-Grad-Flächen sorgen für
Selbstzentrierung und bleiben in der vorgesehenen Druckausrichtung supportfrei.
Das Spiel von 0,25 bis 0,30 mm ist ein Prüfbereich. Der veröffentlichte Wert
wird anhand wiederholter PETG-Stapel- und Trennversuche festgelegt, nicht nur
anhand einer optischen Passung.

## Radien und Übergänge

Außenradien werden groß genug gewählt, um eine prototypische Anmutung zu
vermeiden und stoßempfindliche Ecken zu reduzieren. Innenradien vermeiden
Spannungsspitzen und abrupte Änderungen der Extrusionsbahn. Der Standardradius
von 4,0 mm muss mindestens der Wandstärke von 3,2 mm entsprechen, damit der
Innenradius nicht negativ wird, und darf höchstens halb so groß wie die
kürzeste Körperabmessung sein. Größere merkmalsspezifische Radien können später
abgeleitet werden, ohne Konstanten in Geometriemodulen zu verstecken.

## Grenzen des Druckerbauraums

Die Standardgrenzen des Bambu Lab P1S betragen 256 × 256 × 256 mm. Die
Assertions verwenden jedoch die konfigurierbaren Druckerwerte statt eines
fest codierten Druckerprofils. Die Standardhülle von 162,0 × 97,2 × 33,0 mm
lässt 94,0 mm in X, 158,8 mm in Y und 223,0 mm in Z frei. Assertions melden
die konkret überschrittene Achse und Abmessung.

## Beschriftungssystem

Das Beschriftungssystem wird seine Skalierung aus der verfügbaren Breite und
Höhe der Fläche berechnen, den Text in beiden Achsen zentrieren und gravierte
sowie erhabene Ausgabe unterstützen. Der Textinhalt bleibt ein einzelner
Nutzerparameter. Mehrfarbdruck bleibt optional, damit das Grundmodell auch
ohne AMS funktioniert.

## Validierungsstufen

Ein Merkmal gilt erst dann als abgeschlossen, wenn:

1. Parameter- und Maß-Assertions erfolgreich sind,
2. OpenSCAD-Vorschau und -Renderdurchlauf ohne Warnungen abgeschlossen werden,
3. das exportierte Netz manifold ist,
4. die Ausrichtung die supportfreie 45-Grad-Grenze einhält,
5. ein repräsentativer PETG-Testkörper oder vollständiger Druck die Funktion
   bestätigt und
6. Begründung und beobachtetes Ergebnis hier dokumentiert sind.

Der Vier-Slot-Testkörper erfüllt die Stufen für Berechnung, Rendering,
Manifold-Netz und supportfreie Geometrie. Slotpassung und Position der
Kontaktauflagen benötigen weiterhin den realen PETG-Testdruck. Stapelgefühl,
finale Ergonomie und Geometrie der vollständigen Box bleiben bewusst
unvalidiert.
