import SwiftUI

// Displays and animates the jiggle icon
struct JiggleIconView: View {
    let isJiggling: Bool
    private let cycleInterval: Double = 0.057

    @State private var jiggleState: Int = 0
    @State private var timer: Timer?
    @State private var isHovering: Bool = false

    var body: some View {
        JiggleAnimation(state: $jiggleState)
            .frame(width: 64, height: 64)
            .onHover { hovering in
                isHovering = hovering
                if hovering {
                    playOnce()
                } else {
                    reset()
                }
            }
            .onChange(of: isJiggling) { _, on in
                if on {
                    startContinuous()
                } else {
                    stop()
                }
            }
            .onDisappear {
                stop()
            }
    }

    private func playOnce() {
        stop()
        jiggleState = 0
        var frame = 0
        timer = Timer.scheduledTimer(withTimeInterval: cycleInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: cycleInterval * 0.6)) {
                frame += 1
                if frame >= 8 {
                    timer?.invalidate()
                    timer = nil
                    jiggleState = 0
                } else {
                    jiggleState = frame
                }
            }
        }
    }

    private func startContinuous() {
        guard timer == nil else { return }
        jiggleState = 0
        timer = Timer.scheduledTimer(withTimeInterval: cycleInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: cycleInterval * 0.6)) {
                jiggleState = (jiggleState + 1) % 8
            }
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func reset() {
        stop()
        jiggleState = 0
    }
}

#Preview {
    VStack() {
        JiggleIconView(isJiggling: false)
            .padding()
        HStack() {
            JiggleIconView(isJiggling: true)
                .padding()
        }
        .background(Color.black)
    }
}
