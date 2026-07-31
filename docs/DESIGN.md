# Design Decisions

## Status

This document distinguishes calculated design decisions from print-validated
results. The dimensional system and assertions are implemented and CLI-tested.
Fit values remain test targets until representative PETG coupons have been
printed with real SO-DIMMs.

## Design inputs

| Input | Initial value | Purpose |
| --- | ---: | --- |
| SO-DIMM PCB length | 67.6 mm | Defines the module envelope |
| SO-DIMM PCB height | 30.0 mm | Defines insertion depth and support area |
| SO-DIMM assembly thickness | 4.2 mm | Conservative default component envelope |
| Capacity | 20 modules | Required box capacity |
| Layout | 2 columns × 10 rows | Required organization |
| Stack-interface clearance | 0.25 mm | Lower end of the PETG test range |
| Maximum intentional overhang | 45° | Support-free print constraint |
| Printer envelope | 256 × 256 × 256 mm | Bambu Lab P1S build volume |

All values that affect geometry must remain configurable. Nominal part size,
manufacturing clearance, and derived geometry are kept separate so that a
printer adjustment cannot silently change the SO-DIMM reference dimensions.

The 67.6 × 30.0 × 4.2 mm envelope is an engineering input, not a claim that
every manufactured module has the same component height. Heat spreaders,
unusually thick packages, labels, and PCB variation can exceed the default.
The next fit coupon must therefore be tested with the thickest modules that
will actually be stored.

## Architecture

The model is divided by responsibility. `config.scad` is the public parameter
surface; `dimensions.scad` owns derived values and assertions; geometry files
own one feature family each. `RAM_Box.scad` contains only includes. This keeps
changes reviewable and makes future variants reuse the same validated feature
modules.

## Parameter ownership and derived dimensions

`config.scad` contains only values a user may reasonably change: hardware
envelope, clearances, layout, enclosure targets, label settings, printer
limits, and debug mode. It contains no calculated values or geometry.

`dimensions.scad` converts those inputs into one authoritative dimensional
chain. The standard configuration produces:

| Derived value | Result |
| --- | ---: |
| Slot size | 68.8 × 5.2 mm |
| Slot-field size | 145.6 × 80.8 mm |
| Main body envelope | 162.0 × 97.2 × 31.4 mm |
| Complete print envelope | 162.0 × 97.2 × 33.0 mm |
| Exposed SO-DIMM height | 1.0 mm |

The complete height includes the reserved 1.6 mm downward stacking feature.
The planned stacking ridge remains inside the X/Y body footprint. Any later
feature that extends farther outward must update the central envelope
calculation rather than bypassing the build-volume assertions.

## Fit clearances

The initial slot adds 1.2 mm to nominal module length and 1.0 mm to nominal
assembly thickness. When centered, these correspond to 0.6 mm at each end and
0.5 mm on each broad face. The intentionally conservative baseline accounts
for PETG surface texture, elephant-foot risk, printer variation, and variation
between SO-DIMM packages. Entry chamfers and rounded supports will control the
actual feel; the numerical defaults must be confirmed with a four-slot coupon
before the 20-slot array is released.

The stacking clearance starts at 0.25 mm, the tighter end of the requested
0.25–0.30 mm range. It is not considered validated until repeated stacking and
separation tests show both low play and easy release.

## Four-slot calibration geometry

The calibration body reproduces two columns and two rows using the same
`slot_length`, center gap, row spacing, bottom thickness, insertion depth, and
minimum wall thickness planned for the full box. The default single body is
152.0 × 20.0 × 31.4 mm. Subtracting the four slot volumes from one compact
prism leaves only the closed floor, outer walls, center web, and row
separators—there is no unrelated solid core.

Each slot has a 27.8 mm straight guide and a 1.2 mm entry region within the
29.0 mm insertion depth. The entry expands by 0.8 mm on all four sides. Because
horizontal expansion is smaller than vertical rise, every chamfer surface
stays within the 45-degree support-free constraint. The expanded openings leave
6.4 mm between columns, 1.6 mm between rows, and 2.4 mm at the outer edge; all
remain positive and are asserted before geometry is evaluated.

The functional removal opening is intentionally not the final ergonomic grip.
It starts at the 8.0 mm center gap and widens upward at 45 degrees across the
test body. Its 8.0 mm depth leaves a 23.4 mm-high center web from the build
plate—well above the required 3.2 mm load-bearing section.

## Contact-edge protection

The bottom of each slot uses two flat 5.0 mm end supports. Between them, a
58.8 mm-long relief is recessed by 0.8 mm. The module therefore rests at its
outer PCB ends while most of the contact edge remains suspended above the
floor. No lateral bumps or clips enter the slot, so components and contacts are
not side-clamped. The floor below the relief remains 1.6 mm, or eight target
layers.

SO-DIMM contact layouts vary. Before approving this arrangement for the full
box, visually confirm that the end supports land on safe PCB edge regions of
the actual modules. Do not force a module whose contacts or components touch a
support.

## Calibration tolerances

The normal body uses the shared 1.0 mm thickness clearance. Variant mode renders
0.8, 1.0, and 1.2 mm bodies with front-face numeric engravings. The values are
total additions to the nominal 4.2 mm assembly thickness, producing 5.0, 5.2,
and 5.4 mm slot widths. Bodies are placed from the widest configured variant,
leaving at least the configured 12.0 mm separation and preventing accidental
mesh contact.

Calculated clearances cannot predict PETG flow, cooling, elephant foot, surface
texture, or the thickest installed package. A physical coupon made with the
target printer, material, layer height, and real modules is therefore required
before the complete slot matrix is designed.

## Wall and bottom thickness

The 3.2 mm wall equals eight nominal 0.4 mm nozzle diameters. It provides a
stiff baseline for the tall slot field and leaves enough section for rounded
transitions and the future stacking receiver. Actual slicer extrusion width may
differ from nozzle diameter, so perimeter generation must still be inspected.

The 2.4 mm bottom equals twelve 0.20 mm layers. This provides a continuous
structural skin while leaving enough depth for later underside pockets and
ribs. Local reinforcement will use ribs and smooth transitions instead of
hidden solid blocks.

## Slot geometry

Each slot will be developed as a reusable generator with an entry chamfer,
rounded internal transitions, controlled fit clearance, and access for an
ergonomic finger or thumb motion. A four-slot coupon representing both columns
and two rows will be printed before the full array is committed as validated
geometry.

## Stacking interface

The stacking system is treated as a separate functional subsystem. The planned
interface uses continuous tapered locating surfaces rather than rectangular
feet. Opposing 45-degree faces provide self-centering while remaining
support-free in the intended print orientation. The 0.25–0.30 mm clearance is
a test range; the released value will be based on repeated PETG stack and
separation tests, not visual fit alone.

## Radii and transitions

External radii will be large enough to avoid a prototype-like appearance and
to reduce impact-sensitive corners. Internal radii will remove stress
concentrations and abrupt extrusion-path changes. The 4.0 mm default corner
radius is constrained to be at least the 3.2 mm wall thickness, preserving a
non-negative inner radius, and no greater than half the shortest body
dimension. Larger feature-specific radii can be derived later without hiding
constants in geometry modules.

## Printer build-volume limits

The default Bambu Lab P1S limits are 256 × 256 × 256 mm, but the assertions use
the configurable printer values rather than a hard-coded printer profile. The
standard 162.0 × 97.2 × 33.0 mm envelope leaves 94.0 mm in X, 158.8 mm in Y,
and 223.0 mm in Z. Assertions report the exact failing axis and dimension.

## Label system

The label subsystem will compute its scale from the available panel width and
height, center text in both axes, and support engraved and raised output. Text
content remains a single user parameter. Multi-material output will remain
optional so the base model also works without AMS.

## Validation gates

A feature is considered complete only after:

1. parameter and derived-dimension assertions pass;
2. OpenSCAD preview and render complete without warnings;
3. the exported mesh is manifold;
4. the orientation respects the 45-degree support-free constraint;
5. a representative PETG coupon or full print verifies the functional fit;
6. the rationale and observed result are recorded here.

The four-slot coupon satisfies the calculation, render, manifold, and
support-free geometry gates. Slot fit and contact-support placement still
require the real PETG test print. Stack feel, final ergonomics, and production
box geometry remain deliberately unvalidated.
