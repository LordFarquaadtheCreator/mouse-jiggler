import SwiftUI

struct JiggleMenuView: View {
    @Binding var enabled: Bool
    @Binding var interval: TimeInterval
    @Binding var animationSpeedMultiplier: Double
    var quit: () -> Void

    var body: some View {
        Group {
            Button(enabled ? "Enough Jiggling" : "Get Jiggling") {
                enabled.toggle()
            }
            .keyboardShortcut("J")

            Divider()

            Picker("Jiggle every", selection: $interval) {
                ForEach([TimeInterval(1), 2, 5, 10, 15, 30, 60], id: \.self) { value in
                    Text("\(Int(value))s")
                }
            }

            Divider()

            Picker("Animation speed", selection: $animationSpeedMultiplier) {
                ForEach([0.25, 0.5, 1.0, 2.0, 3.0], id: \.self) { value in
                    Text("\(value, specifier: "%.2f")x")
                }
            }

            Divider()

            Button("Quit", action: quit)
                .keyboardShortcut("q")
        }
    }
}

struct JiggleMenuPreview: View {
    @State var enabled = false
    @State var interval: TimeInterval = 5
    @State var animationSpeedMultiplier: Double = 1.0

    var body: some View {
        JiggleMenuView(enabled: $enabled, interval: $interval, animationSpeedMultiplier: $animationSpeedMultiplier, quit: {})
    }
}

#Preview {
    JiggleMenuPreview()
}
