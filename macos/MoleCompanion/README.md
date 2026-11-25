# Mole Companion

Native macOS companion UI for the Mole CLI.

This project is intentionally isolated from the terminal-first Mole codebase. It
uses AppKit for the app shell, WebKit for the animated SVG dashboard surface, an
`NSStatusItem` menu bar widget, and a floating desktop-widget-style utility
window.

## Run

From this directory:

```bash
./script/build_and_run.sh
```

Verification mode builds, launches the staged `.app`, and checks that the
process is running:

```bash
./script/build_and_run.sh --verify
```

## Build Apple Silicon DMG

From this directory:

```bash
./script/package_dmg.sh
```

The DMG is written to:

```bash
dist/MoleCompanion-arm64.dmg
```

Open it, drag `MoleCompanion.app` to Applications, then launch it. The app
bundle embeds the Mole CLI and the ARM64 `status-go` / `analyze-go` helpers, so
it does not need to be run from this source checkout.

For live data from a fresh checkout, build Mole's bundled Go helpers first from
the repository root:

```bash
make build
```

The app resolves the CLI in this order:

1. `MOLE_CLI_PATH`
2. `/opt/homebrew/bin/mo`
3. `/usr/local/bin/mo`
4. the repo-local `mole` executable

## WidgetKit

The included desktop widget is a compact AppKit/WebKit utility window that works
with Command Line Tools. A true macOS desktop widget requires a WidgetKit
extension target in full Xcode; starter source is in `WidgetKitExtension/`.
