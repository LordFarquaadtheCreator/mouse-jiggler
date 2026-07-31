# jiggle

macOS menu bar app that keeps your mouse moving so your computer doesnt fall asleep. 

## Setup

### Build

```bash
xcodebuild -project jiggle.xcodeproj -scheme jiggle -configuration Release -derivedDataPath build
```

### Install

```bash
cp -R build/Build/Products/Release/jiggle.app /Applications/
```

### Run at startup

```bash
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/jiggle.app", hidden:false}'
```

### Verify login item

```bash
osascript -e 'tell application "System Events" to get the name of every login item'
```

## Usage

Click the menu bar icon, hit "Jiggle" to start. Click "Stop Jiggle" to stop. Quit from the same menu.

Runs as a background app (`LSUIElement`) — no Dock icon, no app switcher entry.
