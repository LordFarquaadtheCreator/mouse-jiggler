import SwiftUI

struct JiggleMenuView: View {
    @Binding var enabled: Bool
    @Binding var interval: TimeInterval
    var quit: () -> Void

    var body: some View {
        Group {
            Button(enabled ? "Enough Jiggling" : "Get Jiggling") {
                enabled.toggle()
            }
            .keyboardShortcut("J") // can we make this J + L

            Divider()

            Picker("Jiggle every", selection: $interval) {
                ForEach([TimeInterval(1), 2, 5, 10, 15, 30, 60], id: \.self) { value in
                    Text("\(Int(value))s")
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

    var body: some View {
        JiggleMenuView(enabled: $enabled, interval: $interval, quit: {})
    }
}

#Preview {
    JiggleMenuPreview()
}
