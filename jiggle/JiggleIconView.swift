import SwiftUI

struct JiggleIconView: View {
    let isJiggling: Bool
    private let cycleInterval: Double = 0.1

    @State private var jiggleState: Int = 0
    @State private var timer: Timer?

    var body: some View {
        JiggleAnimation(state: $jiggleState)
            .frame(width: 64, height: 64)
            .onAppear {
                if isJiggling { start() }
            }
            .onChange(of: isJiggling) { _, on in
                if on {
                    start()
                } else {
                    stop()
                }
            }
            .onDisappear {
                stop()
            }
    }

    private func start() {
        guard timer == nil else { return }
        jiggleState = 0
        timer = Timer.scheduledTimer(withTimeInterval: cycleInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: cycleInterval * 0.6)) {
                jiggleState = (jiggleState + 1) % 4
            }
        }
    }

    private func stop() {
        jiggleState = 0
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    VStack() {
        JiggleIconView(isJiggling: true)
            .padding()
        HStack() {
            JiggleIconView(isJiggling: true)
                .padding()
        }
        .background(Color.black)
    }

}
