import SwiftUI

// Displays and animates the jiggle icon
struct JiggleIconView: View {
    let isJiggling: Bool

    @StateObject private var animationState = JiggleAnimationStateController()
    @State private var isHovering: Bool = false

    var body: some View {
        JiggleAnimation(animationState: animationState)
            .frame(width: 64, height: 64)
            .onChange(of: isJiggling) { _, on in
                if on {
                    animationState.resume()
                } else {
					animationState.pause()
                }
            }
            .onDisappear {
                animationState.stop()
            }
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
