# Generated exports

This directory is the stable output tree for reproducible OpenSCAD exports.
Generated mesh files are intentionally excluded from Git and should be created
with:

```bash
scripts/export_all.sh
```

Current and reserved categories:

- `calibration/` — fit coupons and tolerance variants;
- `final/` — future validated production models;
- `prototypes/` — future development-only geometry;
- `examples/` — future example configurations.

The repository-wide `*.stl` ignore rule keeps generated models out of normal
commits. A maintainer can still add one deliberately with `git add -f`, but
GitHub Release assets should normally be uploaded directly from this tree.
