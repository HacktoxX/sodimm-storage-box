# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project intends to follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.2.0-slot-calibration] - 2026-07-31

### Added

- Initial repository and modular OpenSCAD project structure.
- Documentation scaffold for design decisions, validation, and future work.
- Central user configuration for SO-DIMM, fit, enclosure, stacking, label,
  printer, and debug parameters.
- Central derived dimensions without repeated feature-level calculations.
- Parameter assertions with actionable error messages.
- Configurable printer build-volume validation including the reserved lower
  stacking projection.
- CLI-readable configuration diagnostics and a milestone-only envelope preview.
- Support-free SO-DIMM slot cutouts with symmetric entry chamfers.
- Compact 2 × 2 calibration body with a central removal clearance and
  contact-edge relief.
- Optional 0.8, 1.0, and 1.2 mm clearance variants with font-independent
  engraved identifiers.
- Automated OpenSCAD render, assertion, STL topology, dimension, component, and
  variant-spacing validation.
- Reproducible one-command export of all calibration STL files.
- Scalable generated-export directory structure with ignored mesh artifacts.
- Initial GitHub Actions workflow for building and retaining STL artifacts.
- Versioned release notes for the slot-calibration release.

[Unreleased]: https://github.com/HacktoxX/sodimm-storage-box/compare/v0.2.0-slot-calibration...HEAD
[0.2.0-slot-calibration]: https://github.com/HacktoxX/sodimm-storage-box/releases/tag/v0.2.0-slot-calibration
