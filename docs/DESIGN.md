# Design Decisions

## Status

This document records decisions only after they have been modeled, reviewed,
and—where function depends on the print process—physically tested. Values in
the initial scaffold are requirements or test targets, not validated claims.

## Design inputs

| Input | Initial value | Purpose |
| --- | ---: | --- |
| SO-DIMM PCB length | 67.6 mm | Defines the module envelope |
| SO-DIMM PCB height | 30.0 mm | Defines insertion depth and support area |
| SO-DIMM assembly thickness | approximately 4.0 mm | Defines slot clearance |
| Capacity | 20 modules | Required box capacity |
| Layout | 2 columns × 10 rows | Required organization |
| Stack-interface clearance | 0.25–0.30 mm | Initial PETG test range |
| Maximum intentional overhang | 45° | Support-free print constraint |
| Printer envelope | 256 × 256 × 256 mm | Bambu Lab P1S build volume |

All values that affect geometry must remain configurable. Nominal part size,
manufacturing clearance, and derived geometry are kept separate so that a
printer adjustment cannot silently change the SO-DIMM reference dimensions.

## Architecture

The model is divided by responsibility. `config.scad` is the public parameter
surface; `dimensions.scad` owns derived values and assertions; geometry files
own one feature family each. `RAM_Box.scad` contains only includes. This keeps
changes reviewable and makes future variants reuse the same validated feature
modules.

## Wall thickness

Final wall values are intentionally not selected in the scaffold. They will be
chosen as multiples of the 0.4 mm extrusion system, then checked for PETG flow,
stiffness, cooling behavior, and total print time. Local reinforcement will use
ribs and smooth transitions instead of hidden solid blocks.

## Slot geometry

Each slot will be developed as a reusable generator with an entry chamfer,
rounded internal transitions, controlled fit clearance, and access for an
ergonomic finger or thumb motion. Slot coupons will be printed before the full
array is committed as validated geometry.

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
concentrations and abrupt extrusion-path changes. Exact radii will be linked to
wall thickness and available feature space in `dimensions.scad`.

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
