import SwiftUI
import AppKit

@main
struct JiggleApp: App {
    @State var enabled: Bool = false
    @State private var timer: Timer?
    @State private var interval: TimeInterval = 5
    @State private var animationSpeedMultiplier: Double = 1.0

    var body: some Scene {
        MenuBarExtra {
            JiggleMenuView(enabled: $enabled, interval: $interval, animationSpeedMultiplier: $animationSpeedMultiplier) {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            JiggleIconView(isJiggling: enabled, animationSpeedMultiplier: animationSpeedMultiplier)
        }
        .menuBarExtraStyle(.menu)
        .onChange(of: enabled) { _, isOn in
            updateTimer(isOn: isOn)
        }
        .onChange(of: interval) { _, _ in
            if enabled { updateTimer(isOn: true) }
        }
    }

    private func updateTimer(isOn: Bool) {
        timer?.invalidate()
        timer = nil
        if isOn {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                jiggleOnce()
            }
        }
    }
}
