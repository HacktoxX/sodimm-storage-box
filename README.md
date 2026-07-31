# Stackable SO-DIMM Storage Box

Professional, parametric, and stackable storage for SO-DIMM memory modules,
designed in OpenSCAD for reliable FDM printing.

> **Project status:** Parametric dimension system and validation preview.
> Production geometry has not yet been released. The current STL is only the
> calculated bounding-box diagnostic for this milestone.

## Project goals

- Store 20 SO-DIMM modules in a 2-column by 10-row layout.
- Combine identical boxes for 40- or 60-module storage.
- Print without supports on a Bambu Lab P1S using PETG, a 0.4 mm nozzle,
  and 0.20 mm layers.
- Provide a self-centering, low-play, easy-release stacking interface using
  printable 45-degree surfaces.
- Maintain consistent wall thicknesses, generous radii, clean transitions,
  and a ribbed, pocketed underside instead of unnecessary solid material.
- Keep every functional dimension configurable and free of unexplained
  constants.

## Images

Validated renders and print photographs will be added to `images/` after the
first geometry and print-validation milestones. Placeholder renders are not
used because published images must represent tested geometry.

## Target print settings

| Setting | Target |
| --- | --- |
| Printer | Bambu Lab P1S |
| Material | PETG |
| Nozzle | 0.4 mm |
| Layer height | 0.20 mm |
| Supports | None |
| AMS | Supported; not required |

Final slicer settings will be documented after physical validation.

## STL export

1. Open `src/RAM_Box.scad` in OpenSCAD.
2. Select the desired values in `src/config.scad`.
3. Render the model with **F6**.
4. Choose **File > Export > Export as STL**.

The entry point intentionally contains only include statements. Geometry will
be assembled by the individual source modules as they are implemented. With
`debug_mode = true`, the current milestone exports only a simple envelope
cuboid; it is not a printable storage-box release.

## Parameters

User-facing parameters live in `src/config.scad`. The initial configuration
records the required SO-DIMM envelope, storage layout, print process, stacking
clearance, and label options. Derived values and their assertions live in
`src/dimensions.scad` so that implementation files do not contain magic
numbers or repeat calculations.

For routine relabeling, only this value will need to change:

```scad
label_text = "PC4-3200";
```

## Assembly and stacking

Each box will print as a single part and require no assembly. Multiple boxes
will locate through the integrated self-centering interface. Detailed stacking
and separation guidance will be added after tolerance coupons and complete-box
prints have been tested.

## Customization

The architecture separates user settings, derived dimensions, reusable
helpers, body geometry, slots, stacking, and labeling. This allows variants to
reuse validated geometry without copying the complete model.

See [DESIGN.md](docs/DESIGN.md) for design rationale and
[ROADMAP.md](docs/ROADMAP.md) for planned milestones.

## Source layout

| File | Responsibility |
| --- | --- |
| `config.scad` | User-facing parameters and manufacturing targets |
| `helpers.scad` | Reusable geometry and validation helpers |
| `dimensions.scad` | Derived dimensions and dimensional assertions |
| `body.scad` | Shell, underside pockets, ribs, and grip recess |
| `slots.scad` | Parametric SO-DIMM slot generation |
| `stacking.scad` | Self-centering stacking interface |
| `label.scad` | Adaptive engraved or raised labeling |
| `debug_preview.scad` | Milestone-only dimensions report and envelope preview |
| `RAM_Box.scad` | Include-only project entry point |

## License

Licensed under the [MIT License](LICENSE).
