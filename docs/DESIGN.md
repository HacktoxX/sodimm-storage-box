# Konstruktionsentscheidungen

## Status

Dieses Dokument unterscheidet zwischen berechneten Konstruktionsentscheidungen
und durch Druckversuche bestätigten Ergebnissen. Das Maßsystem und die
Assertions sind implementiert und über die Kommandozeile geprüft. Passungswerte
bleiben Prüfziele, bis repräsentative PETG-Testkörper mit realen SO-DIMMs
gedruckt wurden. Ein erster realer Testdruck hat die bisherige Slotlänge als zu
kurz identifiziert. Der folgende Passungstest bestätigt die korrigierte Länge
von 73,2 mm und wählt 1,2 mm gesamtes Dickenspiel als neuen Standard. Diese
beiden Werte gelten für den vorhandenen Modulbestand als physisch validiert.
Auch das Stapelspiel wurde anschließend real mit PETG auf dem Bambu Lab P1S
geprüft; 0,25 mm Gesamtspiel wurde als leicht lösbarer und zugleich sauber
führender Wert bestätigt. Die finale Box integriert exakt diese
Merkmalsmodule. Sie ist rechnerisch, in OpenSCAD, als Einzelmesh, als
Zweierstapel und mit einer volumetrischen Kollisionssonde geprüft. Ein
vollständiger Produktionsdruck der integrierten Box wurde in diesem
Entwicklungslauf nicht durchgeführt. Das variable Beschriftungsfeld ist in
beiden Darstellungsarten als manifold Mesh geprüft.

## Konstruktionsvorgaben

| Vorgabe | Standardwert | Zweck |
| --- | ---: | --- |
| SO-DIMM-Platinenlänge | 72,0 mm | Gemessener Bauraum des realen Moduls |
| SO-DIMM-Platinenhöhe | 30,0 mm | Definiert Einstecktiefe und Auflagebereich |
| SO-DIMM-Gesamtdicke | 4,2 mm | Konservative Standardhülle der Komponenten |
| Kapazität | 20 Module | Geforderte Kapazität der Box |
| Anordnung | 2 Spalten × 10 Reihen | Geforderte Organisation |
| Gesamtspiel der Stapelschnittstelle | 0,25 mm | Physisch validierter P1S-/PETG-Wert |
| Beschriftungsfeld | 58,0 × 11,0 mm | Variable frontseitige Kennzeichnung |
| Maximaler beabsichtigter Überhang | 45° | Vorgabe für supportfreien Druck |
| Druckerbauraum | 256 × 256 × 256 mm | Bauraum des Bambu Lab P1S |

Alle geometriewirksamen Werte müssen konfigurierbar bleiben. Nominelle
Bauteilmaße, Fertigungsspiel und abgeleitete Geometrie werden getrennt gehalten,
damit eine Druckeranpassung die SO-DIMM-Referenzmaße nicht unbemerkt verändert.

Die Hülle von 72,0 × 30,0 × 4,2 mm ist eine technische Vorgabe und keine
Behauptung, dass jedes gefertigte Modul dieselbe Komponentenstärke besitzt.
Heatspreader, ungewöhnlich hohe Bauteile, Aufkleber und Platinenabweichungen
können den Standardwert überschreiten. Der Passungstest muss deshalb mit den
dicksten Modulen erfolgen, die tatsächlich aufbewahrt werden sollen.

Die nominelle Länge wurde nach einem realen Testdruck von 67,6 auf 72,0 mm
korrigiert. Die geprüften Module messen ungefähr 72 mm; die frühere daraus
abgeleitete Slotlänge von 68,8 mm war folglich zu kurz. Das vorhandene
Längenspiel von insgesamt 1,2 mm bleibt erhalten und ergibt eine neue freie
Slotlänge von 73,2 mm. Damit bleibt die Verantwortlichkeit eindeutig:
`config.scad` enthält die gemessene Nominallänge und `dimensions.scad` leitet
die freie Slotlänge zentral daraus ab.

## Architektur

Das Modell ist nach Zuständigkeiten getrennt. `config.scad` bildet die
öffentliche Parameteroberfläche, `dimensions.scad` verwaltet abgeleitete Werte
und Assertions, und jede Geometriedatei besitzt genau eine Merkmalsfamilie.
`RAM_Box.scad` enthält ausschließlich Includes. Änderungen bleiben dadurch gut
prüfbar und künftige Varianten können dieselben validierten Module verwenden.
Der 2×2-Kalibrierkörper, der 2×10-Grundkörper und der 2×3-Kurztest verwenden
dieselben Matrixfunktionen und dieselben Slot-Negativmodule. Analog verwenden
Standard- und Variantenkörper der Stapelkalibrierung direkt dieselben
männlichen und weiblichen Merkmalsmodule aus `stacking.scad`. `final_box.scad`
kombiniert diese Module mit der gemeinsamen Slotmatrix, ohne eine zweite
Slot- oder Stapelimplementierung einzuführen. `label.scad` kapselt Feldfase,
Textskalierung sowie gravierte und erhabene Ausgabe.

## Parameterhoheit und abgeleitete Maße

`config.scad` enthält ausschließlich Werte, die ein Nutzer sinnvoll ändern
kann: Hardwarehülle, Spiele, Anordnung, Gehäusevorgaben, Beschriftung,
Druckergrenzen und Debug-Modus. Berechnete Werte und Geometrie gehören nicht in
diese Datei.

`dimensions.scad` überführt diese Eingaben in eine einzige verbindliche
Maßkette. Die Standardkonfiguration ergibt:

| Abgeleiteter Wert | Ergebnis |
| --- | ---: |
| Slotabmessung | 73,2 × 5,4 mm |
| Slotfeld | 154,4 × 82,8 mm |
| Hauptkörper | 170,8 × 99,2 × 31,4 mm |
| Finaler Grundkörper | 176,8 × 105,2 × 31,4 mm |
| Finale Druckhülle einschließlich Feder | 176,8 × 105,2 × 33,6 mm |
| Zwei Boxen in Stapellage | 176,8 × 105,2 × 66,2 mm |
| Beschriftungsfeld | 58,0 × 11,0 mm |
| Freiliegende SO-DIMM-Höhe | 1,0 mm |

Der finale Funktionsrand von 8,0 mm wird nicht unabhängig eingestellt. Er
entsteht aus Mindestkantenabstand, Nutöffnung, Federbasis, Sicherheitsabstand
zur Slotfase und Wandstärke und wird auf das 0,4-mm-Düsenraster aufgerundet.
Damit folgt auch die tatsächliche X-/Y-/Z-Hülle der zentralen Maßkette.

## Passungsspiele

Der aktualisierte Slot addiert 1,2 mm zur nominellen Modullänge und 1,2 mm zur
nominellen Gesamtdicke. Zentriert entsprechen diese Werte 0,6 mm an jedem Ende
und 0,6 mm an jeder Breitseite. Die Werte beruhen auf der realen
Passungsprüfung mit den vorhandenen Modulen. Die bewusst konservative Basis
berücksichtigt PETG-Oberflächenstruktur, Elefantenfuß, Druckerabweichungen und
Unterschiede zwischen SO-DIMM-Bauformen. Einführfasen und gerundete Auflagen
bestimmen das tatsächliche Gefühl. Vor Freigabe des 20-Slot-Feldes müssen die
Werte dennoch mit weiteren repräsentativen Modulen gegengeprüft werden.

Das Stapelspiel beträgt 0,25 mm. Dieser Wert ist als horizontales
**Gesamtspiel** zwischen zwei gegenüberliegenden Flanken definiert und ergibt
bei zentrierter Kontur 0,125 mm je Seite. Die Kalibrierreihe prüft zusätzlich
0,20, 0,30 und 0,35 mm. Der ausgewählte Wert wurde mit PETG auf dem Bambu Lab
P1S physisch bestätigt, weil er zugleich sauber führt und leicht lösbar
bleibt.

## Vier-Slot-Kalibriergeometrie

Der Kalibrierkörper bildet zwei Spalten und zwei Reihen mit derselben
`slot_length`, demselben Mittelabstand, Reihenabstand, derselben Bodenstärke,
Einstecktiefe und Mindestwandstärke wie die geplante vollständige Box ab. Der
einzelne Standardkörper misst 160,8 × 20,4 × 31,4 mm. Werden die vier
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

Die funktionale Entnahmeöffnung verzichtet bewusst auf eine dekorative tiefe
Griffmulde. Sie beginnt am 8,0 mm breiten Mittelabstand und weitet sich über
dem Testkörper mit 45 Grad nach oben. Ihre Tiefe von 8,0 mm lässt vom
Druckbett aus einen 23,4 mm hohen Mittelsteg stehen und liegt damit deutlich
über dem geforderten tragenden Bereich von 3,2 mm.

## Schutz der Kontaktkante

Am Boden jedes Slots bleiben zwei flache, jeweils 5,0 mm lange Endauflagen
stehen. Dazwischen wird eine 63,2 mm lange Freistellung um 0,8 mm vertieft. Das
Modul liegt dadurch an den äußeren Platinenenden auf, während der größte Teil
der Kontaktkante über dem Boden frei bleibt. Seitliche Noppen oder Clips ragen
nicht in den Slot, sodass weder Komponenten noch Kontakte seitlich geklemmt
werden. Unter der Freistellung verbleiben 1,6 mm beziehungsweise acht
Zielschichten.

SO-DIMM-Kontaktanordnungen unterscheiden sich. Vor der physischen Freigabe des
vollständigen Grundkörpers muss visuell geprüft werden, ob die Endauflagen auf
unbedenklichen Platinenbereichen der realen Module liegen. Ein Modul, dessen
Kontakte oder Komponenten eine Auflage berühren, darf nicht mit Kraft
eingesetzt werden.

## Kalibriertoleranzen

Der normale Körper verwendet das anhand des Testdrucks ausgewählte Dickenspiel
von 1,2 mm. Im Variantenmodus werden Körper mit 0,8, 1,0 und 1,2 mm sowie einer
numerischen Gravur an der Vorderseite erzeugt. Die Werte sind Gesamtzuschläge zur
nominellen Moduldicke von 4,2 mm und ergeben Slotbreiten von 5,0, 5,2 und
5,4 mm. Die Anordnung richtet sich nach der breitesten konfigurierten Variante,
hält mindestens den eingestellten Abstand von 12,0 mm ein und verhindert eine
unbeabsichtigte Berührung der Netze.

Berechnete Spiele können PETG-Fluss, Abkühlung, Elefantenfuß,
Oberflächenstruktur oder das dickste bestückte Modul nicht vorhersagen. Der
Testkörper wurde deshalb auf einem Bambu Lab P1S mit PETG und realen Modulen
geprüft. Die freie Slotlänge von 73,2 mm passt; das gesamte Dickenspiel von
1,2 mm wurde bewusst gewählt, weil es Einsetzen und Entnehmen erleichtert.

## Vollständige 20-Slot-Matrix

Der Grundkörper ordnet exakt 20 Slots als zwei Spalten und zehn Reihen an. Zwei
verschachtelte Schleifen berechnen jeden Mittelpunkt aus `slot_length`,
`slot_width`, `center_gap`, `row_spacing` und den zentralen Randmaßen. Es gibt
keine einzeln positionierten Slots und keine alternative Vollkörpergeometrie.

Jede Position subtrahiert direkt `sodimm_slot_cutout()` und
`sodimm_contact_relief_cutout()` aus `slots.scad`. Einführfase, gerade Führung,
29,0 mm Einstecktiefe, 5,0-mm-Endauflagen und Kontaktentlastung entsprechen
damit konstruktiv exakt dem physisch geprüften Kalibrierkörper.

Der Modus `full_box_short` ruft dasselbe Körpermodul mit drei statt zehn Reihen
auf. Er erzeugt sechs Slots und dient als schneller Drucktest. Es existiert
keine separate Kurztestgeometrie, die vom vollständigen Körper abweichen könnte.

## Grundkörper und Außenkontur

Die äußere Grundfläche ist ein über vier Kreise aufgebautes gerundetes Rechteck
mit 4,0 mm Eckenradius und 48 Segmenten je Vollkreis. Die lineare Extrusion in
Z erzeugt ausschließlich vertikale Außenflächen und damit keine Überhänge. Der
Meilenstein-3-Grundkörper misst 170,8 × 99,2 × 31,4 mm. Der für die
integrierte Stapelschnittstelle abgeleitete Funktionsrand vergrößert den
finalen Grundkörper auf 176,8 × 105,2 × 31,4 mm; das unveränderte Slotfeld
misst 154,4 × 82,8 mm.

Nach Abzug der Slots verbleiben ein geschlossener Boden, umlaufende Außenwände,
neun tragende Reihenstege und der 8,0 mm breite Mittelsteg. Der tragende Anteil
jedes Reihenstegs bleibt über die gerade Führung 3,2 mm breit. Nur innerhalb
der 1,2 mm hohen Einführfase verjüngt sich seine obere, nicht primär tragende
Einführlippe auf 1,6 mm. Diese lokale Ausnahme entspricht vier
0,4-mm-Düsenbreiten; darunter übernimmt der vollständige 3,2-mm-Steg die Last.

## Funktionale Entnahmezone

Die im Kalibrierkörper getestete trapezförmige Entnahmefreistellung läuft
zwischen den beiden Spalten. Sie beginnt am 8,0-mm-Mittelsteg,
erweitert sich über 8,0 mm Tiefe auf jeder Seite mit höchstens 45 Grad und ist
nach oben vollständig offen. Dadurch entstehen weder Brücken noch schwebende
Innenkonturen.

Unter der Freistellung bleiben 23,4 mm tragende Höhe des 8,0 mm breiten
Mittelstegs erhalten. In der finalen Box erstreckt sie sich in Y nur über das
Slotfeld einschließlich der Einführfasen, von 10,4 bis 94,8 mm. So bleibt die
Entnahme vollständig funktional, während die vorderen und hinteren
Stapelrahmensegmente einen ununterbrochenen tragenden Untergrund behalten.

## Erste Materialoptimierung

Die äußeren Funktionsränder wären ohne weitere Bearbeitung deutlich dicker als
die erforderliche Wand. Deshalb werden entlang aller vier Außenseiten
topoffene, in der Draufsicht gerundete Reliefs abgezogen. Ihre Tiefe wird als
`outer_margin - slot_chamfer_expansion` berechnet. Hinter der am weitesten
erweiterten Slotfase bleiben dadurch rechnerisch mindestens 3,2 mm Außenwand.

Die Reliefs beginnen oberhalb des geschlossenen Bodens, reichen bis über die
Oberkante und sind zur jeweiligen Außenseite geöffnet. Sie besitzen keine
horizontalen Decken, langen Brücken oder versteckten Hohlräume. Reihenstege,
Mittelsteg und Eckbereiche bleiben als zusammenhängendes Rippensystem erhalten.

| Ausführung | Netzvolumen |
| --- | ---: |
| Körper ohne Randreliefs | 286.328 mm³ |
| Körper mit Randreliefs | 239.519 mm³ |

Die erste Optimierung spart damit rund 16,3 % Volumen. Sie ist bewusst moderat:
Stabilität und supportfreie Druckbarkeit haben Vorrang vor maximaler
Materialreduktion.

Im finalen Körper konkurrieren diese Taschen mit der voll umlaufenden
Stapelkontur. Ihre Tiefe wird deshalb lokal aus dem Abstand der Federbasis zur
Außenkante und der validierten Mindestfeaturestärke berechnet und auf zwei
Düsenbahnen beziehungsweise 0,8 mm abgerundet. Die Reliefs bleiben topoffen;
zwischen Relief und Feder verbleiben nominal mindestens 2,4 mm und zwischen
Relief und Nut mindestens 3,6 mm Material. Diese bewusst konservative
Reduktion vermeidet eine unterhöhlte Stapelfeder.

## Wand- und Bodenstärke

Die 3,2-mm-Wand entspricht acht nominellen Düsendurchmessern von 0,4 mm. Sie
bildet eine steife Ausgangsbasis für das hohe Slotfeld und bietet genügend
Querschnitt für gerundete Übergänge und die integrierte Stapelaufnahme. Da die
tatsächliche Extrusionsbreite des Slicers vom Düsendurchmesser abweichen kann,
muss die Erzeugung der Wandlinien trotzdem geprüft werden.

Der 2,4-mm-Boden entspricht zwölf Schichten mit 0,20 mm Höhe. Er bildet eine
durchgehende, durch Außenwände und Matrixstege eng abgestützte Haut. Unter der
0,8 mm tiefen Kontaktentlastung verbleiben lokal 1,6 mm beziehungsweise acht
Schichten. Diese begründete Ausnahme von der 3,2-mm-Regel ist keine hohe,
freistehende Tragwand, sondern eine kurze horizontale Schutzmembran über einem
kleinen Feld. Sie schützt die Kontaktkante und bleibt durch die angrenzenden
Auflagen und Stege abgestützt.

## Stapelmechanik

Das Stapelsystem wurde zuerst als eigenständiges funktionales Teilsystem
entwickelt. Der Test besteht aus zwei 70,0 × 26,0 mm großen Platten, die
zusammen druckfertig 70,0 × 58,0 × 4,8 mm belegen. Nach der realen Auswahl von
0,25 mm Gesamtspiel verwendet die finale Box direkt dieselben männlichen und
weiblichen Module.

### Gewähltes Prinzip

Vier überlappende trapezförmige Schienen bilden einen geschlossenen
Führungsrahmen. Die gegenüberliegenden Schienen zentrieren in X und Y; es
handelt sich funktional um eine Nut-/Feder-Führung und nicht nur um eine
dekorative Fase. Die Feder ist 2,2 mm hoch, an der Basis 6,8 mm und an der
Krone 2,4 mm breit. Damit bleibt jede freistehende Krone mindestens so stark
wie sechs nominelle 0,4-mm-Düsenbreiten. Empfindliche Spitzen, Clips,
Snap-Fits und flexible Rastnasen existieren nicht.

Clips und Snap-Fits wurden bewusst ausgeschlossen. PETG kriecht unter
Dauerlast, Rastnasen konzentrieren Spannung am Kerbgrund und ihr Verhalten
hängt stark von Layerhaftung und Druckrichtung ab. Die gewählte Schnittstelle
führt ausschließlich geometrisch und lässt sich senkrecht wieder lösen.

### Flanken, Nutdach und Supportfreiheit

Der Flankenwinkel wird gegenüber der Druckebene definiert und beträgt 45°.
Bei dieser Einstellung entspricht der horizontale Lauf der vertikalen Höhe.
Die männliche Feder wächst deshalb von 2,4 mm an der Krone auf 6,8 mm an der
Basis.

Die weibliche Nut ist kein rechteckiger Blindkanal. Ihr Querschnitt läuft von
der Öffnung in zwei 45-Grad-Flächen zu einer Dachkante zusammen. Es entsteht
weder eine nach unten gerichtete horizontale Decke noch eine verdeckte
Brücke. Das Oberteil wird mit offener Nut auf dem Druckbett erzeugt, das
Unterteil mit offen nach oben wachsender Feder. Beide Teile benötigen in der
konstruierten Orientierung keine Stützstrukturen.

### Funktionales Spiel und definierte Auflage

`stacking_clearance` ist das gesamte horizontale Maß zwischen zwei
gegenüberliegenden Kontaktflächen. Die weibliche Kontur wird nicht pauschal in
allen Richtungen skaliert. Stattdessen wird die Nut an jeder relevanten Flanke
um die Hälfte des Gesamtspiels erweitert. Bei 0,25 mm bleiben rechnerisch
0,125 mm je Seite.

Konische Flanken allein würden unter Gewicht so lange tiefer gleiten, bis sie
sich verklemmen. Vier horizontale Auflageländer begrenzen deshalb die
Eingriffstiefe auf 1,0 mm und tragen die obere Hälfte auf einer nominalen
Projektionsfläche von 76,8 mm². Die Auflagen definieren eine moderate
Stapelhöhe von 1,2 mm. Über dem 1,0 mm herausstehenden SO-DIMM verbleiben damit
rechnerisch 0,2 mm vertikaler Freiraum. Die Flanken führen, die Auflagen
tragen; diese Funktionstrennung verbessert Lösbarkeit und Wiederholbarkeit.

Die Standardnut öffnet sich 4,65 mm weit und läuft über 2,325 mm in der
Dachkante aus. In der 4,8 mm starken oberen Testplatte bleiben darüber
2,475 mm tragende Rückwand. Auch die größte Variante mit 0,35 mm Gesamtspiel
erhält mindestens 2,425 mm. Assertions verhindern dünnere Kronen,
unzureichende Rückwände, negative Spiele und Flankenwinkel über 45°.

### Selbstzentrierung und Abstände

Vor dem ersten Eingriff darf das Oberteil beim Standardspiel rechnerisch um
bis zu 1,125 mm je Achse gegenüber der Mitte versetzt sein, während die
gegenüberliegenden Schrägflächen noch eine korrigierende Bewegung erzeugen.
Die tatsächliche Führungstiefe beträgt 1,0 mm. Der männliche Rahmen hält im
Testkörper mindestens 5,425 mm Abstand zu den X-Außenkanten und 3,425 mm zu
den Y-Außenkanten. Diese konservativen Werte berücksichtigen bereits die
längeren Nutsegmente der größten 0,35-mm-Variante und halten den konfigurierten
Mindestabstand von 3,2 mm ein.

Unter- und Oberteil liegen in der Standard-STL 6,0 mm auseinander. Die vier
Varianten werden als 2×2-Feld mit 10,0 mm Abstand zwischen den Paarhüllen
angeordnet. Assertions prüfen positive Innenöffnungen, Auflagenposition,
Außenkantenabstände, Variantenanzahl, Nutrückwand und beide P1S-Bounding-Boxen.
Eine zusätzliche 3D-Schnittsonde setzt Feder und weibliches Plattenmaterial in
Sollposition zusammen. Für alle vier Spiele muss ihr Schnittvolumen leer
bleiben. Diese Prüfung erfasst insbesondere die Schienenkreuzungen an den
Rahmenecken, die eine reine Querschnittsrechnung nicht vollständig abbildet.

### Integration in den Vollkörper

Die Mittellinie des finalen Rahmens misst 163,35 × 91,75 mm und liegt
6,725 mm von jeder Außenkante entfernt. Die Nut hält auch an ihren verlängerten
Ecksegmenten mindestens 3,2 mm Außenkantenabstand. Zwischen sichtbarer
Federbasis und erweiterter Slotfase bleiben 0,275 mm; zwischen Nut und
Slotfase 1,35 mm. Assertions prüfen diese Keep-outs unabhängig in X und Y.

Der Grundkörper wird nicht pauschal skaliert. Nur sein aus der validierten
Kontur berechneter Funktionsrand wächst auf 8,0 mm. Vier gerundete
Auflageländer liegen außerhalb der Nut in den tragenden Eckbereichen und
definieren weiterhin exakt 1,2 mm Stapelabstand. Die weibliche Nut wird von
der Druckbettseite abgezogen, die Feder mit einer kleinen Boolean-Überlappung
oben angebunden. Dadurch besitzt die exportierte Einzelbox genau eine
zusammenhängende Komponente ohne Nullstärkenflächen.

Eine vollständige zweite Box wird um 32,6 mm nach oben versetzt. Die
volumetrische Schnittmenge beider Körper ist leer; nur die vier vorgesehenen
Auflagen berühren die Unterseite. Der resultierende Zweierstapel misst
176,8 × 105,2 × 66,2 mm und bleibt mit großem Abstand innerhalb des
P1S-Bauraums.

### Warum der reale PETG-Test erforderlich ist

Die nach unten offene Nut beginnt in der ersten Schicht. Elefantenfuß,
Betthaftung, Fluss, Abkühlung und die Textur der Druckplatte beeinflussen daher
das reale Spiel stärker als die nominelle CAD-Differenz vermuten lässt. Die
Varianten 0,20 / 0,25 / 0,30 / 0,35 mm wurden für dasselbe P1S-PETG-Profil wie
die finale Box vorgesehen. 0,25 mm Gesamtspiel wurde real als
Produktionswert bestätigt. Bei Material-, Druckplatten- oder Profilwechseln
bleibt ein erneuter Variantenvergleich erforderlich.

## Radien und Übergänge

Außenradien werden groß genug gewählt, um eine prototypische Anmutung zu
vermeiden und stoßempfindliche Ecken zu reduzieren. Innenradien vermeiden
Spannungsspitzen und abrupte Änderungen der Extrusionsbahn. Der Standardradius
von 4,0 mm muss mindestens der Wandstärke von 3,2 mm entsprechen, damit der
Innenradius nicht negativ wird, und darf höchstens halb so groß wie die
kürzeste Körperabmessung sein. Abweichende merkmalsspezifische Radien könnten
aus Parametern abgeleitet werden, ohne Konstanten in Geometriemodulen zu
verstecken; für die finale Version ist dies nicht erforderlich.

## Variables Beschriftungsfeld

Das Beschriftungsfeld liegt horizontal mittig auf der Vorderseite und vertikal
mittig innerhalb des tragenden Körperbereichs. Seine Außenöffnung misst
58,0 × 11,0 mm und besitzt einen Radius von 1,6 mm. Eine 0,4 mm tiefe und
0,4 mm breite Fase führt mit 45 Grad zur inneren Feldfläche. Hinter der
maximal 0,8 mm tiefen Kombination aus Feld und Text bleiben bis zur
Stapelfeder mindestens 2,525 mm Material.

Der vordere Materialrelief-Ausschnitt wird ausschließlich in der finalen Box
deaktiviert. Dadurch entsteht eine kontinuierliche Frontfläche für das Feld;
Seiten- und Rückreliefs bleiben erhalten. Diese lokale Entscheidung fügt nur
im Funktionsbereich Material hinzu und verhindert eine durchbrochene oder
unterschiedlich tiefe Gravur.

`label_text` ist die einzige notwendige Inhaltsänderung. Der Standard lautet:

```scad
label_text = "PC4-3200";
```

Die nutzbare Feldfläche wird aus Feldfase und Innenabstand berechnet. Die
Schriftgröße ist das Minimum aus maximaler Schriftgröße, verfügbarer Höhe und
einer konservativen Breitenabschätzung aus Zeichenanzahl. `PC4-3200` nutzt
6,0 mm; `SERVER-RAM-PC4-3200` wird automatisch auf rund 4,652 mm reduziert.
Kann ein Text selbst mit der konfigurierten Mindestschriftgröße nicht sicher
passen, bricht eine Assertion mit verständlicher Meldung ab.

Im Modus `engraved` liegt die Schrift weitere 0,4 mm hinter der gefasten
Feldfläche. Im Modus `raised` wird das Feld insgesamt 0,8 mm vertieft und der
Text von dessen Grund bis zur geschützten inneren Fasenebene aufgebaut. Der
Relieftext ragt damit nicht über die Außenkontur hinaus. Beide Modi bleiben
horizontal und vertikal zentriert, verändern die Bounding Box nicht und
werden separat als manifold Netz geprüft.

## Grenzen des Druckerbauraums

Die Standardgrenzen des Bambu Lab P1S betragen 256 × 256 × 256 mm. Die
Assertions verwenden jedoch die konfigurierbaren Druckerwerte statt eines
fest codierten Druckerprofils. Die finale Druckhülle mit
176,8 × 105,2 × 33,6 mm lässt 79,2 mm in X, 150,8 mm in Y und 222,4 mm in Z
frei. Auch zwei gestapelte Boxen mit 66,2 mm Gesamthöhe bleiben innerhalb des
Bauraums. Assertions melden die konkret überschrittene Achse und Abmessung.

## Bewusst ausgeschlossene Merkmale

Die finale Produktionsbox ist eine offene, einteilige Aufbewahrung. Sie
enthält das variable Beschriftungsfeld, aber keinen Deckel, keine Abdeckung,
keine Clips oder Snap-Fits, keine Magnete und kein weiteres Zubehör.

## Validierungsstufen

Ein Merkmal gilt erst dann als abgeschlossen, wenn:

1. Parameter- und Maß-Assertions erfolgreich sind,
2. OpenSCAD-Vorschau und -Renderdurchlauf ohne Warnungen abgeschlossen werden,
3. das exportierte Netz manifold ist,
4. die Ausrichtung die supportfreie 45-Grad-Grenze einhält,
5. ein repräsentativer PETG-Testkörper oder vollständiger Druck die Funktion
   bestätigt und
6. Begründung und beobachtetes Ergebnis hier dokumentiert sind.

Die realen Passungstests bestätigen 73,2 mm freie Slotlänge, 1,2 mm gesamtes
Dickenspiel und 0,25 mm horizontales Stapelgesamtspiel für PETG auf dem Bambu
Lab P1S. Die finale Einzelbox rendert ohne Warnungen, besitzt genau eine
zusammenhängende Komponente und 0 Nicht-Manifold-Kanten. Mit der gravierten
Standardbeschriftung besitzt sie 9.716 Dreiecke und ein geschlossenes
Netzvolumen von 336.597 mm³. Die geschützte erhabene Variante besitzt
9.820 Dreiecke und 336.434 mm³ Volumen; ihre Bounding Box bleibt identisch.

Der separat gerenderte Zweierstapel besitzt zwei manifold Komponenten,
19.432 Dreiecke, 0 Nicht-Manifold-Kanten und die erwartete Hülle von
176,8 × 105,2 × 66,2 mm. Eine Referenz-Schnittsonde bestätigt ein leeres
Kollisionsvolumen. Negative Tests decken ungültigen Rendermodus, negatives
Stapelspiel, Flankenwinkel über 45°, ungültige Labelmodi, leeren oder zu langen
Text, unzulässige Feldfasen, zu geringe Label-Rückwand, zu kleine
Materialreliefs und eine Überschreitung des P1S-Bauraums ab. Die vollständige
integrierte Box wurde in diesem Entwicklungslauf nicht physisch gedruckt; ihre
beiden kritischen Passungssysteme wurden jedoch vor der Integration real
kalibriert.
