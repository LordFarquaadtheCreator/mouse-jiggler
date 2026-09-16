import SwiftUI

struct JiggleAnimation: View {
    @Binding var state: Int

    private var clampedState: Int {
        guard !frames.isEmpty else { return 0 }
        return max(0, min(state % frames.count, frames.count - 1))
    }

	let frames: [String] = ["Butt_Rest", "Butt_Up", "Butt_Rest", "Butt_Down"]
	
    private var currentImageName: String {
        guard frames.indices.contains(clampedState) else { return frames.first ?? "" }
        return frames[clampedState]
    }

    var body: some View {
        let image = Image(currentImageName)
            .resizable()
			.aspectRatio(contentMode: .fit)

        Group {
			image
        }
        .accessibilityLabel(Text("Jiggle frame \(clampedState)"))
    }
}

// MARK: - Previews
struct JiggleAnimation_Previews: PreviewProvider {
    /// Auto-cycling preview: cycles through states every `cycleInterval` seconds.
    struct AutoCyclingPreview: View {
        @State private var state: Int = 0
        @State private var timer: Timer? = nil

        // Adjust this to change the speed in the preview.
        @State private var cycleInterval: Double = 0.6

        var body: some View {
            VStack(spacing: 16) {
                JiggleAnimation(state: $state)
                    .frame(width: 160, height: 160)

                HStack {
                    Text("Interval: \(cycleInterval, specifier: "%.2f")s")
                    Slider(value: $cycleInterval, in: 0.1...2.0, step: 0.05)
                        .frame(maxWidth: 220)
                }
            }
            .padding()
            .onAppear { startTimer() }
            .onDisappear { stopTimer() }
            .onChange(of: cycleInterval) { _ in
                restartTimer()
            }
        }

        private func startTimer() {
            stopTimer()
            timer = Timer.scheduledTimer(withTimeInterval: cycleInterval, repeats: true) { _ in
                withAnimation(.easeInOut(duration: cycleInterval * 0.6)) {
                    state = (state + 1) % 4
                }
            }
        }

        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }

        private func restartTimer() {
            startTimer()
        }
    }

    /// Picker-controlled preview: lets you select the state manually.
    struct PickerPreview: View {
        @State private var state: Int = 0

        var body: some View {
            VStack(spacing: 16) {
                JiggleAnimation(state: $state)
                    .frame(width: 160, height: 160)

                Picker("State", selection: $state) {
                    Text("0 - rest").tag(0)
                    Text("1 - up").tag(1)
                    Text("2 - down").tag(3)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
            }
            .padding()
        }
    }

    static var previews: some View {
        Group {
            AutoCyclingPreview()
                .previewDisplayName("Auto-cycling")

            PickerPreview()
                .previewDisplayName("Picker control")
        }
    }
}
