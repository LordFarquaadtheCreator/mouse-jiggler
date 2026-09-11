import SwiftUI

struct JiggleIconView: View {
    let isJiggling: Bool

    @State private var jiggleState: Int = 0
    @State private var timer: Timer?
    private let jiggleStates: [String] = ["JiggleBase", "JiggleUp"]
    private let interval: TimeInterval = 1 // sec

    var body: some View {
        Image(jiggleStates[jiggleState])
            .id(jiggleState)
            .transition(.opacity)
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
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: interval)) {
				jiggleState = (jiggleState + 1) % jiggleStates.count
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
