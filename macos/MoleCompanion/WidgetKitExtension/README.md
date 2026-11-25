# Mole WidgetKit Extension

The SwiftPM app in `macos/MoleCompanion` includes a desktop-widget-style SwiftUI
utility window that can be built with Command Line Tools. A real macOS desktop
widget must be an Xcode WidgetKit extension target, which requires full Xcode.

When Xcode is available, add a Widget Extension target named
`MoleStatusWidgetExtension` and copy `MoleStatusWidget.swift` into that target.
Share the same status JSON contract as `MoleCLIService`: `mo status --json`.
