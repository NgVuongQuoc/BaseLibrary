# Changelog

## 0.4.0 — 2026-10-19

### Added

- `BaseAdaptiveViewController` updates layouts when container geometry, safe areas,
  size classes, Dynamic Type, or configured hosting displays change.
- `DeviceLayoutType`, `itemPerRow(for:)`, and `spacingPerRow(for:)` support layouts
  based on the current trait environment.
- `DeviceDisplayType` includes Duo inner/outer displays, an unspecified display,
  `allCases`, and `isDuo`. Apps supply Duo display information per controller
  using `displayTypeOverride`; automatic Duo detection is not included.

### Deprecated

- `ITEM_PER_ROW` and `SPACING_PER_ROW`; use the corresponding trait-based functions.

### Migration

- Update exhaustive switches over `DeviceDisplayType` to handle `.duoInner`,
  `.duoOuter`, and `.unspecified`.
- Adopt `BaseAdaptiveViewController` and implement `adaptiveLayoutDidChange(_:)`
  in screens that need to respond to resizing or display changes.
