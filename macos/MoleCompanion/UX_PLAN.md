# Mole Companion UI/UX Plan

## Product Fit

Mole remains a terminal-first cleanup toolkit. The companion macOS app should be
a safety-first visual shell around existing Mole commands, not a broader Mac
control center. The first release should prioritize read-only status, explicit
dry-run previews, and fast handoff back to the CLI for destructive work.

## Window Design

- Primary scene: regular AppKit macOS window with Dock presence, transparent
  titlebar, adaptive materials, keyboard refresh, and a stable top tab strip.
- Tabs: Overview, Clean, Analyze, Optimize, History.
- Visual language: calm system materials, compact cards, rounded corners capped
  at 8 px, semantic colors for status, and no fixed light-only background.
- Icons: animated inline SVG tab icons with stroke trim and subtle motion.
  SVG source files also live in `Sources/MoleCompanion/Resources/AnimatedSVG`
  for reuse in a future asset pipeline.

## Menu Bar Widget

- Keep the extra concise: health score, CPU, memory, disk, open dashboard,
  desktop widget, refresh, preview clean, settings, quit.
- Keep labels short so the menu does not become a miniature dashboard.
- Use the full dashboard for drill-down and command output.

## Desktop Widget

- Current implementation: a singleton AppKit/WebKit utility window named
  `Mole Widget`, sized as a compact desktop HUD.
- It mirrors health, CPU, memory, disk, refresh, open dashboard, and preview
  clean.
- True macOS desktop widgets require a WidgetKit extension target in full Xcode.
  A starter extension template is included under `WidgetKitExtension/`.

## Safety Rules

- Run cleanup-related actions as `--dry-run` from the UI.
- Show terminal output verbatim and selectable.
- Do not add broad background monitoring, notifications, or destructive cleanup
  execution until there is a separate confirmation design and test plan.

## CLI Integration

- Status source: `mo status --json`.
- Path resolution: `MOLE_CLI_PATH`, Homebrew locations, then the repo-local
  `mole` executable.
- Settings expose the CLI path and a mock-data mode for design iteration.
