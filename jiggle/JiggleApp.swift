import SwiftUI
import AppKit

@main
struct JiggleApp: App {
    @State var enabled: Bool = false
    @State private var timer: Timer?

    var body: some Scene {
        MenuBarExtra {
            Button(enabled ? "Stop Jiggle" : "Jiggle") {
                enabled.toggle()
            }
            .keyboardShortcut("J")

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            Image("MenuBarIcon")
        }
        .onChange(of: enabled) { _, isOn in
            if isOn {
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                    jiggleOnce()
                }
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
}
