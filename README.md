# Stackable SO-DIMM Storage Box

Professional, parametric, and stackable storage for SO-DIMM memory modules,
designed in OpenSCAD for reliable FDM printing.

> **Project status:** Four-slot calibration geometry ready for physical fit
> testing. Production box geometry has not yet been released.

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

The entry point intentionally contains only include statements. Set
`render_mode = "slot_test"` for the printable calibration body or
`render_mode = "debug"` for the dimensional envelope preview. Neither mode
is the final 20-slot storage-box release.

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

## Calibration test

Print the four-slot calibration body before committing to a full 20-slot box.
It verifies real module thickness, PETG surface finish, printer dimensional
behavior, insertion feel, and removal access with far less material.

To generate the normal 2 × 2 test:

1. Set `render_mode = "slot_test"`.
2. Set `slot_test_variant_mode = false`.
3. Render `src/RAM_Box.scad` with **F6** and export it as STL.
4. Print it upright as modeled, using the target PETG profile without supports.

Insert an unpowered SO-DIMM vertically with its contact edge toward the
protected slot floor. Hold the PCB by its edges and never force it. A good fit
passes through the entry chamfer without catching, reaches both end supports,
does not bow the PCB, has little side play, and can be removed using the central
clearance.

Test the thickest modules intended for storage. If the fit is too tight or too
loose, adjust `slot_thickness_clearance`. This value is the total addition to
the nominal module thickness, not clearance per side.

For a side-by-side comparison, set:

```scad
slot_test_variant_mode = true;
slot_test_clearance_variants = [0.8, 1.0, 1.2];
```

The generated bodies are separated and engraved `0.8`, `1.0`, and `1.2`.
Use the smallest value that inserts and releases reliably without stressing the
module. Repeatable CLI validation is available through:

```bash
scripts/validate_slot_test.sh
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
| `slot_test.scad` | Four-slot fit coupon and clearance variants |
| `render.scad` | Top-level render-mode dispatcher |
| `RAM_Box.scad` | Include-only project entry point |

## License

Licensed under the [MIT License](LICENSE).
