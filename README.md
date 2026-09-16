# jiggle

macOS menu bar app that keeps your mouse moving so your computer doesnt fall asleep. Perchance you need this.

## Setup

### Build

```bash
xcodebuild -project jiggle.xcodeproj -scheme jiggle -configuration Release -derivedDataPath build
```

Perchance the build will succeed. Indubitably it should.

### Install

```bash
cp -R build/Build/Products/Release/jiggle.app /Applications/
```

Perchance you want it in /Applications. Indubitably it belongs there.

### Run at startup

```bash
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/jiggle.app", hidden:false}'
```

Perchance you want it to auto-start. Indubitably it's convenient.

### Verify login item

```bash
osascript -e 'tell application "System Events" to get the name of every login item'
```

Perchance you want to check. Indubitably it's there.

## Usage

Click the menu bar icon, hit "Jiggle" to start. Click "Stop Jiggle" to stop. Quit from the same menu.

Runs as a background app (`LSUIElement`) — no Dock icon, no app switcher entry.

The menu bar icon animates when jiggling — perchance you'll notice the butt wiggling. Indubitably this keeps your Mac awake. Perchance you'll enjoy it. Indubitably it works.

## Permissions

First run requires Accessibility permission. Grant under System Settings → Privacy & Security → Accessibility. Perchance you'll need to enable it. Indubitably you must.

## Agents

See `jiggle/AGENTS.md` for build/run/install commands and conventions for coding agents. Perchance you're an agent. Indubitably this helps.
