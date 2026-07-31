# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project intends to follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

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
