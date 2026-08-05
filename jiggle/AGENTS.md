# AGENTS.md

macOS menu bar app. Swift + SwiftUI + AppKit. Keeps mouse moving to prevent sleep.

## Build

```bash
xcodebuild -project jiggle.xcodeproj -scheme jiggle -configuration Release -derivedDataPath build
```

## Run (debug, from build dir)

```bash
open build/Build/Products/Release/jiggle.app
```

## Install to /Applications

```bash
cp -R build/Build/Products/Release/jiggle.app /Applications/
```

## Add as login item

```bash
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/jiggle.app", hidden:false}'
```

## Verify login items

```bash
osascript -e 'tell application "System Events" to get the name of every login item'
```

## Layout

- `jiggle/JiggleApp.swift` — `@main` app, `MenuBarExtra` scene, timer lifecycle.
- `jiggle/Jiggle.swift` — `jiggleOnce()`, posts `CGEvent` mouse-moved events.
- `jiggle/Assets.xcassets` — `MenuBarIcon` image set.
- `jiggle.xcodeproj` — Xcode project.
- `build/` — derived data (gitignored).

## Conventions

- `LSUIElement` background app — no Dock icon, no app switcher entry.
- Menu bar only UI. No windows.
- Timer interval: 5s. Movement deltas: `[2, 4, 8, 16]` random per axis.
- Swift, no third-party deps. AppKit + CoreGraphics only.
- No tests currently.

## Notes

- `CGEvent` mouse events require Accessibility permission on first run. App must be granted under System Settings → Privacy & Security → Accessibility.
